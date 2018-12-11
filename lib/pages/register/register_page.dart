import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo_redux/models/app_state.dart';
import 'package:flutter_todo_redux/redux/actions/user_actions.dart';
import 'package:flutter_todo_redux/typedefs.dart';
import 'package:flutter_todo_redux/widgets/register/register_form.dart';
import 'package:flutter_todo_redux/widgets/ui_elements/loading_modal.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.from(store),
      builder: (context, vm) {
        Stack stack = Stack(
          children: <Widget>[
            RegisterForm(vm.onRegister),
          ],
        );

        if (vm.isLoading) {
          stack.children.add(LoadingModal());
        }

        return stack;
      },
    );
  }
}

class _ViewModel {
  final bool isLoading;
  final OnRegisterUser onRegister;

  _ViewModel({
    @required this.isLoading,
    @required this.onRegister,
  });

  factory _ViewModel.from(Store<AppState> store) {
    return _ViewModel(
        isLoading: store.state.isLoading,
        onRegister: (
          String email,
          String password,
          OnSuccess onSuccess,
          OnError onError,
        ) {
          store.dispatch(UserRegisterAction(
            email,
            password,
            onSuccess,
            onError,
          ));
        });
  }
}
