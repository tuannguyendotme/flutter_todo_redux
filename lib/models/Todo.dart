import 'package:flutter/material.dart';

import 'package:flutter_todo_redux/models/priority.dart';

class Todo {
  final String id;
  final String title;
  final String content;
  final Priority priority;
  final bool isDone;
  final String userId;

  Todo({
    @required this.id,
    @required this.title,
    this.content,
    this.priority = Priority.Low,
    this.isDone = false,
    @required this.userId,
  });

  Todo copyWith({
    String id,
    String title,
    String content,
    Priority priority,
    bool isDone,
    String userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
    );
  }
}
