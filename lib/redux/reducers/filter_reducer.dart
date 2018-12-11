import 'package:redux/redux.dart';

import 'package:flutter_todo_redux/models/filter.dart';
import 'package:flutter_todo_redux/redux/actions/filter_actions.dart';

final filterReducer = combineReducers<Filter>([
  TypedReducer<Filter, ApplyFilterAction>(_applyFilter),
]);

Filter _applyFilter(Filter filter, dynamic action) {
  return action.filter;
}
