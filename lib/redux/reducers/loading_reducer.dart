import 'package:redux/redux.dart';

import 'package:flutter_todo/redux/actions/todos_actions.dart';
import 'package:flutter_todo/redux/actions/user_actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, LoadTodosAction>(_setLoadingTrue),
  TypedReducer<bool, TodosLoadedAction>(_setLoadingFalse),
  TypedReducer<bool, TodosNotLoadedAction>(_setLoadingFalse),
  TypedReducer<bool, CreateTodoAction>(_setLoadingTrue),
  TypedReducer<bool, TodoCreatedAction>(_setLoadingFalse),
  TypedReducer<bool, TodoNotCreatedAction>(_setLoadingFalse),
  TypedReducer<bool, UpdateTodoAction>(_setLoadingTrue),
  TypedReducer<bool, TodoUpdatedAction>(_setLoadingFalse),
  TypedReducer<bool, DeleteTodoAction>(_setLoadingTrue),
  TypedReducer<bool, TodoDeletedAction>(_setLoadingFalse),
  TypedReducer<bool, ToggleTodoDoneAction>(_setLoadingTrue),
  TypedReducer<bool, TodoDoneToggledAction>(_setLoadingFalse),
  TypedReducer<bool, UserAuthenticateAction>(_setLoadingTrue),
  TypedReducer<bool, UserAuthenticatedAction>(_setLoadingFalse),
  TypedReducer<bool, UserNotAuthenticatedAction>(_setLoadingFalse),
]);

bool _setLoadingTrue(bool isLoading, dynamic action) {
  print('_setLoadingTrue');

  return true;
}

bool _setLoadingFalse(bool isLoading, dynamic action) {
  print('_setLoadingFalse');

  return false;
}
