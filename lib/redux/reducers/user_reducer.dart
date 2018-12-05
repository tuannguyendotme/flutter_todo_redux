import 'package:redux/redux.dart';

import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/redux/actions/user_actions.dart';

final userReducer = combineReducers<User>([
  TypedReducer<User, UserAuthenticatedAction>(_setUser),
  TypedReducer<User, UserLoggedOutAction>(_logOut),
  TypedReducer<User, UserRegisteredAction>(_register),
]);

User _setUser(User user, UserAuthenticatedAction action) {
  return action.user;
}

User _logOut(User user, UserLoggedOutAction action) {
  return null;
}

User _register(User user, UserRegisteredAction action) {
  return action.user;
}
