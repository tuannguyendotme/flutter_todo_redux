import 'package:redux/redux.dart';

import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';

final todosReducer = combineReducers<List<Todo>>([
  TypedReducer<List<Todo>, TodosLoadedAction>(_setTodos),
  TypedReducer<List<Todo>, TodoCreatedAction>(_addTodo),
  TypedReducer<List<Todo>, TodoUpdatedAction>(_updateTodo),
  TypedReducer<List<Todo>, TodoDeletedAction>(_deleteTodo),
  TypedReducer<List<Todo>, TodoDoneToggledAction>(_toggleTodoStatus),
]);

List<Todo> _setTodos(List<Todo> todos, TodosLoadedAction action) {
  print('_setTodos - TodosLoadedAction');

  return action.todos;
}

List<Todo> _addTodo(List<Todo> todos, TodoCreatedAction action) {
  return List.from(todos)..add(action.todo);
}

List<Todo> _updateTodo(List<Todo> todos, TodoUpdatedAction action) {
  return todos
      .map((todo) => todo.id == action.todo.id ? action.todo : todo)
      .toList();
}

List<Todo> _deleteTodo(List<Todo> todos, TodoDeletedAction action) {
  return todos.where((todo) => todo.id != action.id).toList();
}

List<Todo> _toggleTodoStatus(List<Todo> todos, TodoDoneToggledAction action) {
  return todos
      .map((todo) => todo.id == action.todo.id
          ? todo.copyWith(isDone: !todo.isDone)
          : todo)
      .toList();
}