import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/user.dart';

class AppState {
  final bool isLoading;
  final List<Todo> todos;
  final Settings settings;
  final User user;

  AppState({
    this.isLoading = false,
    this.todos = const [],
    this.settings,
    this.user,
  });

  AppState copyWith({
    bool isLoading,
    List<Todo> todos,
    Settings settings,
    User user,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      todos: todos ?? this.todos,
      user: user ?? this.user,
    );
  }
}
