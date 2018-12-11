import 'package:redux/redux.dart';

import 'package:flutter_todo/models/settings.dart';
import 'package:flutter_todo/redux/actions/settings_actions.dart';

final settingsReducer = combineReducers<Settings>([
  TypedReducer<Settings, SettingsLoadedAction>(
    _setSettings,
  ),
  TypedReducer<Settings, ShortcutsEnabledSettingToggledAction>(
    _toggleShortcutsEnabledSetting,
  ),
  TypedReducer<Settings, DarkThemeUsedSettingToggledAction>(
    _toggleDarkThemeUsedSetting,
  ),
]);

Settings _setSettings(
  Settings settings,
  SettingsLoadedAction action,
) {
  return action.settings;
}

Settings _toggleShortcutsEnabledSetting(
  Settings settings,
  ShortcutsEnabledSettingToggledAction action,
) {
  return settings.copyWith(isShortcutsEnabled: !settings.isShortcutsEnabled);
}

Settings _toggleDarkThemeUsedSetting(
  Settings settings,
  DarkThemeUsedSettingToggledAction action,
) {
  return settings.copyWith(isDarkThemeUsed: !settings.isDarkThemeUsed);
}
