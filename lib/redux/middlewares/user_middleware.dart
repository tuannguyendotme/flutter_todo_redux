import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/redux/actions/user_actions.dart';
import 'package:flutter_todo/redux/actions/todos_actions.dart';

List<Middleware<AppState>> createUserMiddleware() {
  return [
    TypedMiddleware<AppState, UserAuthenticateAction>(_authenticate),
    TypedMiddleware<AppState, UserLogOutAction>(_logOut),
    TypedMiddleware<AppState, UserRegisterAction>(_register),
  ];
}

Future _authenticate(
  Store<AppState> store,
  UserAuthenticateAction action,
  NextDispatcher next,
) async {
  print('_authenticate - Middleware');

  next(action);

  final Map<String, dynamic> formData = {
    'email': action.email,
    'password': action.password,
    'returnSecureToken': true,
  };

  try {
    final http.Response response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${Configure.ApiKey}',
      body: json.encode(formData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    String message;

    if (responseData.containsKey('idToken')) {
      final User user = User(
        id: responseData['localId'],
        email: responseData['email'],
        token: responseData['idToken'],
      );

      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', responseData['localId']);
      prefs.setString('email', responseData['email']);
      prefs.setString('token', responseData['idToken']);
      prefs.setString('refreshToken', responseData['refreshToken']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());

      store.dispatch(UserAuthenticatedAction(user));
      store.dispatch(LoadTodosAction());

      return;
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Email is not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Password is invalid.';
    } else if (responseData['error']['message'] == 'USER_DISABLED') {
      message = 'The user account has been disabled.';
    }

    store.dispatch(UserNotAuthenticatedAction());
    action.onError(message);
  } catch (error) {
    store.dispatch(UserNotAuthenticatedAction());
    action.onError(error);
  }
}

Future _logOut(
  Store<AppState> store,
  UserLogOutAction action,
  NextDispatcher next,
) async {
  next(action);

  final prefs = await SharedPreferences.getInstance();
  prefs.clear();

  store.dispatch(UserLoggedOutAction());
}

Future _register(Store<AppState> store, UserRegisterAction action,
    NextDispatcher next) async {
  next(action);

  final Map<String, dynamic> formData = {
    'email': action.email,
    'password': action.password,
    'returnSecureToken': true,
  };

  try {
    final http.Response response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${Configure.ApiKey}',
      body: json.encode(formData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    String message;

    if (responseData.containsKey('idToken')) {
      final User user = User(
        id: responseData['localId'],
        email: responseData['email'],
        token: responseData['idToken'],
      );

      // setAuthTimeout(int.parse(responseData['expiresIn']));

      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', responseData['localId']);
      prefs.setString('email', responseData['email']);
      prefs.setString('token', responseData['idToken']);
      prefs.setString('refreshToken', responseData['refreshToken']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());

      store.dispatch(UserRegisteredAction(user));
      action.onSuccess();

      return;
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email is already exists.';
    } else if (responseData['error']['message'] == 'OPERATION_NOT_ALLOWED') {
      message = 'Password sign-in is disabled.';
    } else if (responseData['error']['message'] ==
        'TOO_MANY_ATTEMPTS_TRY_LATER') {
      message =
          'We have blocked all requests from this device due to unusual activity. Try again later.';
    }

    store.dispatch(UserNotRegisteredAction());
    action.onError(message);
  } catch (error) {
    store.dispatch(UserNotRegisteredAction());
    action.onError(error);
  }
}
