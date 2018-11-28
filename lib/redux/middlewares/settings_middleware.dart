import 'package:redux/redux.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/redux/actions/settings_actions.dart';

List<Middleware<AppState>> createSettingsMiddleware() {
  return [
    TypedMiddleware<AppState, LoadSettingsAction>(_loadSettings),
  ];
}

Future _loadSettings(Store<AppState> store, LoadSettingsAction action,
    NextDispatcher next) async {
  print('_loadSettings - Middleware');

  final prefs = await SharedPreferences.getInstance();
  final isDarkThemeUsed = _loadIsDarkThemeUsed(prefs);

  final Settings settings = Settings(
    isShortcutsEnabled: _loadIsShortcutsEnabled(prefs),
    isDarkThemeUsed: isDarkThemeUsed,
  );

  store.dispatch(SettingsLoadedAction(settings));

  next(action);
}

bool _loadIsShortcutsEnabled(SharedPreferences prefs) {
  return prefs.getKeys().contains('isShortcutsEnabled') &&
      prefs.getBool('isShortcutsEnabled');
}

bool _loadIsDarkThemeUsed(SharedPreferences prefs) {
  return prefs.getKeys().contains('isDarkThemeUsed') &&
      prefs.getBool('isDarkThemeUsed');
}
