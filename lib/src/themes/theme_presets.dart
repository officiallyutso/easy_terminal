import 'package:flutter/material.dart';
import '../models/terminal_theme.dart';

class TerminalThemePresets {
  static const Map<String, TerminalTheme> themes = {
    'crt_green': TerminalTheme(
      backgroundColor: Color(0xFF000000),
      foregroundColor: Color(0xFF00FF00),
      cursorColor: Color(0xFF00FF00),
      borderColor: Color(0xFF00FF00),
      enableGlow: true,
      enableScanlines: true,
      glowRadius: 3.0,
    ),
    'amber': TerminalTheme(
      backgroundColor: Color(0xFF000000),
      foregroundColor: Color(0xFFFFB000),
      cursorColor: Color(0xFFFFB000),
      borderColor: Color(0xFFFFB000),
      enableGlow: true,
      glowRadius: 2.0,
    ),
    'dos': TerminalTheme(
      backgroundColor: Color(0xFF000080),
      foregroundColor: Color(0xFFFFFFFF),
      cursorColor: Color(0xFFFFFFFF),
      borderColor: Color(0xFF0000FF),
      fontFamily: 'Consolas',
      fontSize: 14.0,
    ),
    'commodore': TerminalTheme(
      backgroundColor: Color(0xFF40318D),
      foregroundColor: Color(0xFFA5A5FF),
      cursorColor: Color(0xFFA5A5FF),
      borderColor: Color(0xFF7A70CA),
      fontFamily: 'Courier New',
      fontSize: 14.0,
    ),
    'apple_ii': TerminalTheme(
      backgroundColor: Color(0xFF000000),
      foregroundColor: Color(0xFF00FF00),
      cursorColor: Color(0xFF00FF00),
      borderColor: Color(0xFF00FF00),
      fontFamily: 'Monaco',
      fontSize: 13.0,
    ),
  };

  static TerminalTheme? getTheme(String name) => themes[name];
  
  static List<String> get themeNames => themes.keys.toList();
}

class TerminalThemeBuilder {
  TerminalTheme _theme = TerminalThemes.crtGreen;

  TerminalThemeBuilder();

  TerminalThemeBuilder.from(TerminalTheme theme) : _theme = theme;

  TerminalThemeBuilder backgroundColor(Color color) {
    _theme = _theme.copyWith(backgroundColor: color);
    return this;
  }

  TerminalThemeBuilder foregroundColor(Color color) {
    _theme = _theme.copyWith(foregroundColor: color);
    return this;
  }

  TerminalThemeBuilder cursorColor(Color color) {
    _theme = _theme.copyWith(cursorColor: color);
    return this;
  }

  TerminalThemeBuilder borderColor(Color color) {
    _theme = _theme.copyWith(borderColor: color);
    return this;
  }

  TerminalThemeBuilder font(String fontFamily, double fontSize) {
    _theme = _theme.copyWith(fontFamily: fontFamily, fontSize: fontSize);
    return this;
  }

  TerminalThemeBuilder enableGlow(bool enable, [double radius = 2.0]) {
    _theme = _theme.copyWith(enableGlow: enable, glowRadius: radius);
    return this;
  }

  TerminalThemeBuilder enableScanlines(bool enable) {
    _theme = _theme.copyWith(enableScanlines: enable);
    return this;
  }

  TerminalThemeBuilder borders(double radius, double width) {
    _theme = _theme.copyWith(borderRadius: radius, borderWidth: width);
    return this;
  }

  TerminalTheme build() => _theme;
}