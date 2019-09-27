import 'dart:async';

import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_redux/.env.dart';
import 'package:flutter_todo_redux/app_builder.dart';
import 'package:flutter_todo_redux/models/app_state.dart';
import 'package:flutter_todo_redux/models/user.dart';
import 'package:flutter_todo_redux/models/settings.dart';
import 'package:flutter_todo_redux/models/filter.dart';
import 'package:flutter_todo_redux/redux/actions/todos_actions.dart';
import 'package:flutter_todo_redux/redux/reducers/app_reducer.dart';
import 'package:flutter_todo_redux/redux/middlewares/middlewares.dart';
import 'package:flutter_todo_redux/pages/todo/todo_list_page.dart';
import 'package:flutter_todo_redux/pages/todo/todo_editor_page.dart';
import 'package:flutter_todo_redux/pages/settings/settings_page.dart';
import 'package:flutter_todo_redux/pages/auth/auth_page.dart';
import 'package:flutter_todo_redux/pages/register/register_page.dart';

void main() async {
  final User user = await _autoAuthenticate();
  final Settings settings = await _loadSettings();

  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState(
      settings: settings,
      user: user,
      filter: Filter.All,
    ),
    middleware: []
      ..addAll(createTodosMiddleware())
      ..addAll(createSettingsMiddleware())
      ..addAll(createUserMiddleware()),
  );

  runApp(TodoApp(store));
}

Future<Settings> _loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkThemeUsed = prefs.getBool('isDarkThemeUsed') ?? false;
  final isShortcutsEnabled = prefs.getBool('isShortcutsEnabled') ?? false;

  final Settings settings = Settings(
    isDarkThemeUsed: isDarkThemeUsed,
    isShortcutsEnabled: isShortcutsEnabled,
  );

  return settings;
}

Future<User> _autoAuthenticate() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token');

  if (token != null) {
    final String expiryTimeString = prefs.getString('expiryTime');
    final DateTime now = DateTime.now();
    final parsedExpiryTime = DateTime.parse(expiryTimeString);

    if (parsedExpiryTime.isBefore(now)) {
      return null;
    }

    final user = User(
      id: prefs.getString('userId'),
      email: prefs.getString('email'),
      token: token,
    );

    // final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
    // setAuthTimeout(tokenLifespan);

    return user;
  }

  return null;
}

class TodoApp extends StatefulWidget {
  final Store<AppState> store;

  TodoApp(this.store);

  @override
  State<StatefulWidget> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: widget.store,
      child: AppBuilder(
        builder: (BuildContext context) {
          return MaterialApp(
            title: Configure.AppName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              accentColor: Colors.blue,
              brightness: widget.store.state.settings.isDarkThemeUsed
                  ? Brightness.dark
                  : Brightness.light,
            ),
            initialRoute: '/',
            routes: {
              '/': (BuildContext context) => StoreBuilder<AppState>(
                    onInit: (Store store) {
                      if (store.state.user != null) {
                        store.dispatch(LoadTodosAction());
                      }
                    },
                    builder: (BuildContext context, Store store) {
                      return store.state.user != null
                          ? TodoListPage()
                          : AuthPage();
                    },
                  ),
              '/settings': (BuildContext context) =>
                  widget.store.state.user != null ? SettingsPage() : AuthPage(),
              '/register': (BuildContext context) => RegisterPage(),
            },
            onGenerateRoute: (RouteSettings settings) {
              final List<String> pathElements = settings.name.split('/');

              if (pathElements[0] != '') {
                return null;
              }

              if (widget.store.state.user == null) {
                return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => AuthPage(),
                );
              }

              if (pathElements[1] == 'editor') {
                final String todoId =
                    pathElements.length >= 3 ? pathElements[2] : null;
                final String priority =
                    pathElements.length == 4 ? pathElements[3] : null;

                return MaterialPageRoute<bool>(
                  builder: (BuildContext context) =>
                      TodoEditorPage(todoId, priority),
                );
              }

              return null;
            },
          );
        },
      ),
    );
  }
}
