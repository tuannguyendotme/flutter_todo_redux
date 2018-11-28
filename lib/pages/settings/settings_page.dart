import 'package:flutter/material.dart';
import 'package:flutter_todo/redux/actions/settings_actions.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/settings.dart';
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
        IconButton(
          icon: Icon(Icons.lock),
          onPressed: () async {
            bool confirm = await ConfirmDialog.show(context);

            if (confirm) {
              Navigator.pop(context);

              // model.logout();
            }
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

  _ViewModel({
    @required this.settings,
    @required this.isLoading,
    @required this.toggleIsShortcutEnabled,
    @required this.toggleDarkThemeUsed,
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
    );
  }
}
