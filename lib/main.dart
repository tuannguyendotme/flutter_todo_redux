import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/app_builder.dart';
import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';
import 'package:flutter_todo/redux/reducers/app_reducer.dart';
import 'package:flutter_todo/redux/middlewares/todos_middleware.dart';
import 'package:flutter_todo/redux/middlewares/settings_middleware.dart';
import 'package:flutter_todo/pages/todo/todo_list_page.dart';
import 'package:flutter_todo/pages/todo/todo_editor_page.dart';
import 'package:flutter_todo/pages/settings/settings_page.dart';

void main() async {
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState(
      isLoading: true,
      settings: await _loadSettings(),
    ),
    middleware: []
      ..addAll(createTodosMiddleware())
      ..addAll(createSettingsMiddleware()),
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
          final state = widget.store.state;

          return MaterialApp(
            title: Configure.AppName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              accentColor: Colors.blue,
              brightness: state.settings.isDarkThemeUsed
                  ? Brightness.dark
                  : Brightness.light,
            ),
            routes: {
              '/': (BuildContext context) => StoreBuilder<AppState>(
                    onInit: (Store store) {
                      store.dispatch(LoadTodosAction());
                    },
                    builder: (BuildContext context, Store store) {
                      return TodoListPage();
                    },
                  ),
              '/settings': (BuildContext context) => SettingsPage(),
            },
            onGenerateRoute: (RouteSettings settings) {
              final List<String> pathElements = settings.name.split('/');

              if (pathElements[0] != '') {
                return null;
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
