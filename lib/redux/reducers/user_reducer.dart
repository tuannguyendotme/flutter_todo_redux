import 'package:redux/redux.dart';

import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/redux/actions/user_actions.dart';

final userReducer = combineReducers<User>([
  TypedReducer<User, UserAuthenticatedAction>(_setUser),
  TypedReducer<User, UserLoggedOutAction>(_logOut),
]);

User _setUser(User user, UserAuthenticatedAction action) {
  print('_setUser - UserAuthenticatedAction');
  print(action.user);

  return action.user;
}

User _logOut(User user, UserLoggedOutAction action) {
  print('_setUser - UserLoggedOutAction');

  return null;
}
