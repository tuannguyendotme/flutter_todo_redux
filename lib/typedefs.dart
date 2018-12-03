import 'package:flutter_todo/models/priority.dart';
import 'package:flutter_todo/models/todo.dart';

typedef OnPressed();

typedef OnToggled(bool isSelected);

typedef OnPrioritySelected(Priority priority);

typedef OnSuccess();

typedef OnError(String message);

typedef OnCreateTodo(
  String title,
  String content,
  Priority priority,
  bool isDone,
  OnSuccess onSuccess,
  OnError onError,
);

typedef OnUpdateTodo(
  Todo todo,
  OnSuccess onSuccess,
  OnError onError,
);

typedef OnDeleteTodo(
  String id,
  OnError onError,
);

typedef OnToggleTodoDone(
  Todo todo,
  OnError onError,
);

typedef OnAuthenticateUser(
  String email,
  String password,
  OnSuccess onSuccess,
  OnError onError,
);
