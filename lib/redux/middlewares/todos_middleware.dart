import 'dart:async';

import 'package:redux/redux.dart';

import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';

List<Middleware<AppState>> createTodosMiddleware() {
  return [
    TypedMiddleware<AppState, LoadTodosAction>(_setTodos),
  ];
}

Future _setTodos(
    Store<AppState> store, LoadTodosAction action, NextDispatcher next) async {
  print('_setTodos - Middleware');

  final todos = await Future.delayed(
      Duration(seconds: 3),
      () => [
            Todo(id: '1', title: 'Todo 1', userId: 'userId'),
            Todo(id: '2', title: 'Todo 2', userId: 'userId'),
            Todo(id: '3', title: 'Todo 3', userId: 'userId'),
            Todo(id: '4', title: 'Todo 4', userId: 'userId'),
            Todo(id: '5', title: 'Todo 5', userId: 'userId'),
          ]);

  store.dispatch(TodosLoadedAction(todos));

  next(action);
}

// List<Middleware<AppState>> createTodosMiddleware() {
//   final setTodos = _setTodos();

//   return [
//     TypedMiddleware<AppState, LoadTodosAction>(setTodos),
//   ];
// }

// Middleware<AppState> _setTodos() {
//   return (Store<AppState> store, action, NextDispatcher next) async {
//     print('_setTodos - Middleware');

//     final todos = await Future.delayed(
//         Duration(seconds: 3),
//         () => [
//               Todo(id: '1', title: 'Todo 1', userId: 'userId'),
//               Todo(id: '2', title: 'Todo 2', userId: 'userId'),
//               Todo(id: '3', title: 'Todo 3', userId: 'userId'),
//               Todo(id: '4', title: 'Todo 4', userId: 'userId'),
//               Todo(id: '5', title: 'Todo 5', userId: 'userId'),
//             ]);

//     store.dispatch(TodosLoadedAction(todos));

//     next(action);
//   };
// }
