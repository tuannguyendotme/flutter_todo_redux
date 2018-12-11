import 'package:flutter_todo_redux/models/settings.dart';

class LoadSettingsAction {}

class SettingsLoadedAction {
  final Settings settings;

  SettingsLoadedAction(this.settings);
}

class ToggleShortcutsEnabledSettingAction {}

class ShortcutsEnabledSettingToggledAction {}

class ToggleDarkThemeUsedSettingAction {}

class DarkThemeUsedSettingToggledAction {}
