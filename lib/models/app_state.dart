import 'package:flutter_todo_redux/models/filter.dart';
import 'package:flutter_todo_redux/models/settings.dart';
import 'package:flutter_todo_redux/models/todo.dart';
import 'package:flutter_todo_redux/models/user.dart';

class AppState {
  final bool isLoading;
  final Filter filter;
  final List<Todo> todos;
  final Settings settings;
  final User user;

  AppState({
    this.isLoading = false,
    this.filter = Filter.All,
    this.todos = const [],
    this.settings,
    this.user,
  });

  AppState copyWith({
    bool isLoading,
    Filter filter,
    List<Todo> todos,
    Settings settings,
    User user,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
      settings: settings ?? this.settings,
      todos: todos ?? this.todos,
      user: user ?? this.user,
    );
  }
}
