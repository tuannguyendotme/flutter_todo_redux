import 'package:flutter_todo/models/settings.dart';

class LoadSettingsAction {}

class SettingsLoadedAction {
  final Settings settings;

  SettingsLoadedAction(this.settings);
}

class ToggleShortcutsEnabledSettingAction {
  final Settings settings;

  ToggleShortcutsEnabledSettingAction(this.settings);
}

class ToggleDarkThemeUsedSettingAction {
  final Settings settings;

  ToggleDarkThemeUsedSettingAction(this.settings);
}
