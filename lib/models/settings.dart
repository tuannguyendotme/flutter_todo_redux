import 'package:flutter/material.dart';

class Settings {
  final bool isShortcutsEnabled;
  final bool isDarkThemeUsed;

  Settings({
    @required this.isShortcutsEnabled,
    @required this.isDarkThemeUsed,
  });

  Settings copyWith({
    bool isShortcutsEnabled,
    bool isDarkThemeUsed,
  }) {
    return Settings(
      isShortcutsEnabled: isShortcutsEnabled ?? this.isShortcutsEnabled,
      isDarkThemeUsed: isDarkThemeUsed ?? this.isDarkThemeUsed,
    );
  }
}
