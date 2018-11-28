import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/models/todo.dart';

class AppState {
  final bool isLoading;
  final List<Todo> todos;
  final Settings settings;

  AppState({
    this.isLoading = false,
    this.todos = const [],
    this.settings,
  });

  AppState copyWith({
    bool isLoading,
    List<Todo> todos,
    Settings settings,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      todos: todos ?? this.todos,
    );
  }
}
