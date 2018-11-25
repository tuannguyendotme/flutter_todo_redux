import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';

class LoadTodosAction {}

class TodosLoadedAction {
  final List<Todo> todos;

  TodosLoadedAction(this.todos);
}

class TodosNotLoadedAction {}

class CreateTodoAction {
  final String title;
  final String content;
  final Priority priority;
  final bool isDone;
  final String userId;
  final OnSuccess onSuccess;
  final OnError onError;

  CreateTodoAction(
    this.title,
    this.content,
    this.priority,
    this.isDone,
    this.userId,
    this.onSuccess,
    this.onError,
  );
}

class TodoCreatedAction {
  final Todo todo;

  TodoCreatedAction(this.todo);
}

class TodoNotCreatedAction {}

class UpdateTodoAction {
  final Todo todo;
  final OnSuccess onSuccess;
  final OnError onError;

  UpdateTodoAction(
    this.todo,
    this.onSuccess,
    this.onError,
  );
}

class TodoUpdatedAction {
  final Todo todo;

  TodoUpdatedAction(this.todo);
}

class TodoNotUpdatedAction {}

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
