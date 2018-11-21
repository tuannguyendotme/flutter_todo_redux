import 'package:flutter_todo/models/settings.dart';

class LoadSettingsAction {}

class ToggleShortcutsEnabledSettingAction {
  final Settings settings;

  ToggleShortcutsEnabledSettingAction(this.settings);
}

class ToggleDarkThemeUsedSettingAction {
  final Settings settings;

  ToggleDarkThemeUsedSettingAction(this.settings);
}
