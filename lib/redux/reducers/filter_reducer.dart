import 'package:flutter_todo/redux/actions/filter_actions.dart';
import 'package:redux/redux.dart';

import 'package:flutter_todo/models/filter.dart';

final filterReducer = combineReducers<Filter>([
  TypedReducer<Filter, ApplyFilterAction>(_applyFilter),
]);

Filter _applyFilter(Filter filter, dynamic action) {
  return action.filter;
}
