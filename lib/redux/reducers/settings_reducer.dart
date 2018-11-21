import 'package:redux/redux.dart';

import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/redux/actions/settings_actions.dart';

final settingsReducer = combineReducers<Settings>([
  TypedReducer<Settings, ToggleShortcutsEnabledSettingAction>(
      _toggleShortcutsEnabledSetting),
  TypedReducer<Settings, ToggleDarkThemeUsedSettingAction>(
      _toggleDarkThemeUsedSetting),
]);

Settings _toggleShortcutsEnabledSetting(
    Settings settings, ToggleShortcutsEnabledSettingAction action) {
  return settings.copyWith(isShortcutsEnabled: !settings.isShortcutsEnabled);
}

Settings _toggleDarkThemeUsedSetting(
    Settings settings, ToggleDarkThemeUsedSettingAction action) {
  return settings.copyWith(isDarkThemeUsed: !settings.isDarkThemeUsed);
}
