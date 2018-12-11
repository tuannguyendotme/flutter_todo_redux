import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/models/user.dart';

class UserAuthenticateAction {
  final String email;
  final String password;
  final OnError onError;

  UserAuthenticateAction(
    this.email,
    this.password,
    this.onError,
  );
}

class UserAuthenticatedAction {
  final User user;

  UserAuthenticatedAction(this.user);
}

class UserNotAuthenticatedAction {
  UserNotAuthenticatedAction();
}

class UserLogOutAction {}

class UserLoggedOutAction {}

class UserRegisterAction {
  final String email;
  final String password;
  final OnSuccess onSuccess;
  final OnError onError;

  UserRegisterAction(
    this.email,
    this.password,
    this.onSuccess,
    this.onError,
  );
}

class UserRegisteredAction {
  final User user;

  UserRegisteredAction(this.user);
}

class UserNotRegisteredAction {}

class RefreshTokenAction {
  final dynamic previousAction;

  RefreshTokenAction(this.previousAction);
}
