import 'dart:async';

import 'package:redux/redux.dart';

import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';

List<Middleware<AppState>> createTodosMiddleware() {
  return [
    TypedMiddleware<AppState, LoadTodosAction>(_loadTodos),
    TypedMiddleware<AppState, CreateTodoAction>(_createTodo),
    TypedMiddleware<AppState, UpdateTodoAction>(_updateTodo),
    TypedMiddleware<AppState, DeleteTodoAction>(_deleteTodo),
  ];
}

Future _loadTodos(
    Store<AppState> store, LoadTodosAction action, NextDispatcher next) async {
  print('_loadTodos - Middleware');

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

Future _createTodo(
    Store<AppState> store, CreateTodoAction action, NextDispatcher next) async {
  print('_createTodo - Middleware');

  next(action);

  final todo = await Future.delayed(
    Duration(seconds: 3),
    () => Todo(
          id: '6',
          title: action.title,
          content: action.content,
          priority: action.priority,
          isDone: action.isDone,
          userId: action.userId,
        ),
  );

  store.dispatch(TodoCreatedAction(todo));
  action.onSuccess();

  // action.onError();
  // store.dispatch(TodoNotCreatedAction());
}

Future _updateTodo(
    Store<AppState> store, UpdateTodoAction action, NextDispatcher next) async {
  print('_updateTodo - Middleware');

  next(action);

  final todo = await Future.delayed(
    Duration(seconds: 3),
    () => action.todo,
  );

  store.dispatch(TodoUpdatedAction(todo));
  action.onSuccess();

  // action.onError();
  // store.dispatch(TodoNotUpdatedAction());
}

Future _deleteTodo(
    Store<AppState> store, DeleteTodoAction action, NextDispatcher next) async {
  print('_updateTodo - Middleware');

  next(action);

  store.dispatch(TodoDeletedAction(action.id));

  await Future.delayed(Duration(seconds: 3));

  // store.dispatch(TodoNotDeletedAction());
  // action.onError("Fail to delete todo.");
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
