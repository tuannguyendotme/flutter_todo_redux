import 'package:redux/redux.dart';

import 'package:flutter_todo/redux/actions/todos_actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, TodosLoadedAction>(_setLoadingFalse),
  TypedReducer<bool, AddTodoAction>(_setLoadingTrue),
  TypedReducer<bool, TodoAddedAction>(_setLoadingFalse),
  TypedReducer<bool, UpdateTodoAction>(_setLoadingTrue),
  TypedReducer<bool, TodoUpdatedAction>(_setLoadingFalse),
  TypedReducer<bool, DeleteTodoAction>(_setLoadingTrue),
  TypedReducer<bool, TodoDeletedAction>(_setLoadingFalse),
  TypedReducer<bool, ToggleTodoDoneAction>(_setLoadingTrue),
  TypedReducer<bool, TodoDoneToggledAction>(_setLoadingFalse),
]);

bool _setLoadingTrue(bool isLoading, dynamic action) {
  print('_setLoadingTrue');

  return true;
}

bool _setLoadingFalse(bool isLoading, dynamic action) {
  print('_setLoadingFalse');

  return false;
}
