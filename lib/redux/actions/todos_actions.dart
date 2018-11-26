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
  final OnError onError;

  DeleteTodoAction(this.id, this.onError);
}

class TodoDeletedAction {
  final String id;

  TodoDeletedAction(this.id);
}

class TodoNotDeletedAction {}

class ToggleTodoDoneAction {
  final Todo todo;
  final OnError onError;

  ToggleTodoDoneAction(this.todo, this.onError);
}

class TodoDoneToggledAction {
  final Todo todo;

  TodoDoneToggledAction(this.todo);
}
