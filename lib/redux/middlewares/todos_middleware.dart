import 'dart:async';
import 'dart:convert';

import 'package:flutter_todo/widgets/helpers/priority_helper.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';

List<Middleware<AppState>> createTodosMiddleware() {
  return [
    TypedMiddleware<AppState, LoadTodosAction>(_loadTodos),
    TypedMiddleware<AppState, CreateTodoAction>(_createTodo),
    TypedMiddleware<AppState, UpdateTodoAction>(_updateTodo),
    TypedMiddleware<AppState, DeleteTodoAction>(_deleteTodo),
    TypedMiddleware<AppState, ToggleTodoDoneAction>(_toggleTodoDone),
  ];
}

Future _loadTodos(
  Store<AppState> store,
  LoadTodosAction action,
  NextDispatcher next,
) async {
  print('_loadTodos - Middleware');

  next(action);

  final User user = store.state.user;

  try {
    final http.Response response = await http.get(
        '${Configure.FirebaseUrl}/todos.json?auth=${user.token}&orderBy="userId"&equalTo="${user.id}"');

    if (response.statusCode != 200 && response.statusCode != 201) {
      // action.onError('Fail to load todos.');
      store.dispatch(TodosNotLoadedAction());

      return;
    }

    final Map<String, dynamic> todoListData = json.decode(response.body);
    final List<Todo> todos = [];

    if (todoListData != null) {
      todoListData.forEach((String todoId, dynamic todoData) {
        final Todo todo = Todo(
          id: todoId,
          title: todoData['title'],
          content: todoData['content'],
          priority: PriorityHelper.toPriority(todoData['priority']),
          isDone: todoData['isDone'],
          userId: user.id,
        );

        todos.add(todo);
      });
    }

    store.dispatch(TodosLoadedAction(todos));
  } catch (error) {
    // action.onError(error);
    store.dispatch(TodosNotLoadedAction());
  }
}

Future _createTodo(
  Store<AppState> store,
  CreateTodoAction action,
  NextDispatcher next,
) async {
  next(action);

  final User user = store.state.user;
  final Map<String, dynamic> formData = {
    'title': action.title,
    'content': action.content,
    'priority': action.priority.toString(),
    'isDone': action.isDone,
    'userId': user.id,
  };

  try {
    final http.Response response = await http.post(
      '${Configure.FirebaseUrl}/todos.json?auth=${user.token}',
      body: json.encode(formData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      action.onError('Failed to create new todo.');
      store.dispatch(TodoNotCreatedAction());

      return;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    Todo todo = Todo(
      id: responseData['name'],
      title: action.title,
      content: action.content,
      priority: action.priority,
      isDone: action.isDone,
      userId: user.id,
    );

    store.dispatch(TodoCreatedAction(todo));
    action.onSuccess();
  } catch (error) {
    action.onError(error);
    store.dispatch(TodoNotCreatedAction());
  }
}

Future _updateTodo(
  Store<AppState> store,
  UpdateTodoAction action,
  NextDispatcher next,
) async {
  next(action);

  final User user = store.state.user;
  final Todo todo = action.todo;

  final Map<String, dynamic> formData = {
    'title': todo.title,
    'content': todo.content,
    'priority': todo.priority.toString(),
    'isDone': todo.isDone,
    'userId': user.id,
  };

  try {
    final http.Response response = await http.put(
      '${Configure.FirebaseUrl}/todos/${action.todo.id}.json?auth=${user.token}',
      body: json.encode(formData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      action.onError('Failed to update todo.');
      store.dispatch(TodoNotUpdatedAction());

      return;
    }

    store.dispatch(TodoUpdatedAction(todo));
    action.onSuccess();
  } catch (error) {
    action.onError(error);
    store.dispatch(TodoNotUpdatedAction());
  }
}

Future _deleteTodo(
  Store<AppState> store,
  DeleteTodoAction action,
  NextDispatcher next,
) async {
  next(action);

  store.dispatch(TodoDeletedAction(action.todo));

  try {
    final User user = store.state.user;

    final http.Response response = await http.delete(
        '${Configure.FirebaseUrl}/todos/${action.todo.id}.json?auth=${user.token}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      store.dispatch(TodoNotDeletedAction(action.todo));
      action.onError('Failed to delete todo.');

      return;
    }

    action.onSuccess(action.todo);
  } catch (error) {
    store.dispatch(TodoNotDeletedAction(action.todo));
    action.onError(error);
  }
}

Future _toggleTodoDone(
  Store<AppState> store,
  ToggleTodoDoneAction action,
  NextDispatcher next,
) async {
  next(action);

  final todo = await Future.delayed(
    Duration(seconds: 3),
    () => action.todo.copyWith(isDone: !action.todo.isDone),
  );

  store.dispatch(TodoDoneToggledAction(todo));

  // action.onError();
  // store.dispatch(TodoNotUpdatedAction());
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
