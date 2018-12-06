import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo/typedefs.dart';
import 'package:flutter_todo/app_builder.dart';
import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/redux/actions/user_actions.dart';
import 'package:flutter_todo/redux/actions/settings_actions.dart';
import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/helpers/confirm_dialog.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (Store store) => _ViewModel.from(store),
      builder: (BuildContext context, _ViewModel vm) {
        return _buildPageContent(context, vm);
      },
    );
  }

  Widget _buildAppBar(BuildContext context, _ViewModel vm) {
    return AppBar(
      title: Text('Settings'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String choice) async {
            switch (choice) {
              case 'LogOut':
                bool confirm = await ConfirmDialog.show(context);

                if (confirm) {
                  Navigator.pop(context);

                  vm.onLogOut();
                }
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'LogOut',
                child: Text('Log out'),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildPageContent(BuildContext context, _ViewModel vm) {
    return vm.isLoading
        ? LoadingModal()
        : Scaffold(
            appBar: _buildAppBar(context, vm),
            body: ListView(
              children: <Widget>[
                SwitchListTile(
                  activeColor: Colors.blue,
                  value: vm.settings.isShortcutsEnabled,
                  onChanged: (value) {
                    vm.toggleIsShortcutEnabled();
                  },
                  title: Text('Enable shortcuts'),
                ),
                SwitchListTile(
                  activeColor: Colors.blue,
                  value: vm.settings.isDarkThemeUsed,
                  onChanged: (value) {
                    vm.toggleDarkThemeUsed();

                    AppBuilder.of(context).rebuild();
                  },
                  title: Text('Use dark theme'),
                )
              ],
            ),
          );
  }
}

class _ViewModel {
  final Settings settings;
  final bool isLoading;
  final Function toggleIsShortcutEnabled;
  final Function toggleDarkThemeUsed;
  final OnLogOut onLogOut;

  _ViewModel({
    @required this.settings,
    @required this.isLoading,
    @required this.toggleIsShortcutEnabled,
    @required this.toggleDarkThemeUsed,
    @required this.onLogOut,
  });

  factory _ViewModel.from(Store<AppState> store) {
    return _ViewModel(
      settings: store.state.settings,
      isLoading: store.state.isLoading,
      toggleIsShortcutEnabled: () {
        store.dispatch(ToggleShortcutsEnabledSettingAction());
      },
      toggleDarkThemeUsed: () {
        store.dispatch(ToggleDarkThemeUsedSettingAction());
      },
      onLogOut: () {
        store.dispatch(UserLogOutAction());
      },
    );
  }
}
