import 'package:flutter_todo/models/todo.dart';

class LoadTodosAction {}

class TodosLoadedAction {
  final List<Todo> todos;

  TodosLoadedAction(this.todos);
}

class AddTodoAction {
  final Todo todo;

  AddTodoAction(this.todo);
}

class TodoAddedAction {}

class UpdateTodoAction {
  final Todo todo;

  UpdateTodoAction(this.todo);
}

class TodoUpdatedAction {}

class DeleteTodoAction {
  final String id;

  DeleteTodoAction(this.id);
}

class TodoDeletedAction {}

class ToggleTodoDoneAction {
  final String id;

  ToggleTodoDoneAction(this.id);
}

class TodoDoneToggledAction {}
