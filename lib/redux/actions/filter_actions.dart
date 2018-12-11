import 'package:flutter_todo_redux/models/filter.dart';

class ApplyFilterAction {
  final Filter filter;

  ApplyFilterAction(this.filter);
}

class FilterAppliedAction {}
