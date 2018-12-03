import 'package:flutter_todo/models/app_state.dart';

import 'package:flutter_todo/redux/reducers/loading_reducer.dart';
import 'package:flutter_todo/redux/reducers/todos_reducer.dart';
import 'package:flutter_todo/redux/reducers/settings_reducer.dart';
import 'package:flutter_todo/redux/reducers/user_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    todos: todosReducer(state.todos, action),
    settings: settingsReducer(state.settings, action),
    user: userReducer(state.user, action),
  );
}
