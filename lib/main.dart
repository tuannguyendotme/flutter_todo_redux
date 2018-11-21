import 'package:flutter/material.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo/.env.dart';

import 'package:flutter_todo/models/app_state.dart';

import 'package:flutter_todo/redux/reducers/app_reducer.dart';
import 'package:flutter_todo/redux/middlewares/todos_middleware.dart';

import 'package:flutter_todo/pages/todo/todo_list_page.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: createTodosMiddleware(),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: Configure.AppName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.blue,
          brightness: Brightness.light,
        ),
        routes: {
          '/': (BuildContext context) => StoreBuilder<AppState>(
                onInit: (store) => store.dispatch(LoadTodosAction()),
                builder: (context, store) {
                  return TodoListPage();
                },
              ),
        },
      ),
    );
  }
}
