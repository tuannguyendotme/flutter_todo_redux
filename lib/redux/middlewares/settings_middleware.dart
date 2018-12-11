import 'package:redux/redux.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo/models/app_state.dart';
import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/redux/actions/settings_actions.dart';

List<Middleware<AppState>> createSettingsMiddleware() {
  return [
    TypedMiddleware<AppState, LoadSettingsAction>(_loadSettings),
    TypedMiddleware<AppState, ToggleShortcutsEnabledSettingAction>(
        _toggleShortcutsEnabledSetting),
    TypedMiddleware<AppState, ToggleDarkThemeUsedSettingAction>(
        _toggleDarkThemeUsedSetting),
  ];
}

Future _loadSettings(Store<AppState> store, LoadSettingsAction action,
    NextDispatcher next) async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkThemeUsed = _loadIsDarkThemeUsed(prefs);

  final Settings settings = Settings(
    isShortcutsEnabled: _loadIsShortcutsEnabled(prefs),
    isDarkThemeUsed: isDarkThemeUsed,
  );

  store.dispatch(SettingsLoadedAction(settings));

  next(action);
}

Future _toggleShortcutsEnabledSetting(Store<AppState> store,
    ToggleShortcutsEnabledSettingAction action, NextDispatcher next) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isShortcutsEnabled', !_loadIsShortcutsEnabled(prefs));

  store.dispatch(ShortcutsEnabledSettingToggledAction());

  next(action);
}

Future _toggleDarkThemeUsedSetting(Store<AppState> store,
    ToggleDarkThemeUsedSettingAction action, NextDispatcher next) async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkThemeUsed = !_loadIsDarkThemeUsed(prefs);
  prefs.setBool('isDarkThemeUsed', isDarkThemeUsed);

  store.dispatch(DarkThemeUsedSettingToggledAction());

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
