import 'package:flutter_todo_redux/models/app_state.dart';
import 'package:flutter_todo_redux/redux/reducers/loading_reducer.dart';
import 'package:flutter_todo_redux/redux/reducers/todos_reducer.dart';
import 'package:flutter_todo_redux/redux/reducers/settings_reducer.dart';
import 'package:flutter_todo_redux/redux/reducers/user_reducer.dart';
import 'package:flutter_todo_redux/redux/reducers/filter_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    todos: todosReducer(state.todos, action),
    settings: settingsReducer(state.settings, action),
    user: userReducer(state.user, action),
    filter: filterReducer(state.filter, action),
  );
}
