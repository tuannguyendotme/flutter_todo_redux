import 'package:flutter/material.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/app_builder.dart';
import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/widgets/helpers/message_dialog.dart';
import 'package:flutter_todo/widgets/ui_elements/rounded_button.dart';

class AuthForm extends StatefulWidget {
  final OnAuthenticateUser onAuthenticate;

  AuthForm(this.onAuthenticate);

  @override
  State<StatefulWidget> createState() {
    return _AuthFormState();
  }
}

class _AuthFormState extends State<AuthForm> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: Text(Configure.AppName),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailField(),
                    _buildPasswordField(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildButtonRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _authenticate() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    widget.onAuthenticate(
      _formData['email'],
      _formData['password'],
      this._onSuccess,
      this._onError,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter password';
        }
      },
      onSaved: (value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RoundedButton(
          icon: Icon(Icons.edit),
          label: 'Register',
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
        ),
        SizedBox(
          width: 20.0,
        ),
        RoundedButton(
          icon: Icon(Icons.lock_open),
          label: 'Login',
          onPressed: _authenticate,
        ),
      ],
    );
  }

  void _onSuccess() {
    print('rebuild');

    // AppBuilder.of(context).rebuild();

    Navigator.pushReplacementNamed(context, '/');
  }

  void _onError(String message) {
    MessageDialog.show(context, message: message);
  }
}
