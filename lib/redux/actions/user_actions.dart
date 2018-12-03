import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/models/user.dart';

class UserAuthenticateAction {
  final String email;
  final String password;
  final OnSuccess onSuccess;
  final OnError onError;

  UserAuthenticateAction(
    this.email,
    this.password,
    this.onSuccess,
    this.onError,
  );
}

class UserAuthenticatedAction {
  final User user;

  UserAuthenticatedAction(this.user);
}

class UserNotAuthenticatedAction {
  final String message;

  UserNotAuthenticatedAction(this.message);
}

class LogOutAction {}
