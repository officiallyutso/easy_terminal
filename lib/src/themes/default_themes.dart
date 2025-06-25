import 'package:flutter/material.dart';
import '../models/terminal_theme.dart';

class TerminalThemes {
  static const TerminalTheme crtGreen = TerminalTheme(
    backgroundColor: Color(0xFF000000),
    foregroundColor: Color(0xFF00FF00),
    cursorColor: Color(0xFF00FF00),
    borderColor: Color(0xFF00FF00),
    enableGlow: true,
    enableScanlines: true,
    glowRadius: 3.0,
    fontFamily: 'Courier New',
    fontSize: 14.0,
  );

  static const TerminalTheme amber = TerminalTheme(
    backgroundColor: Color(0xFF000000),
    foregroundColor: Color(0xFFFFB000),
    cursorColor: Color(0xFFFFB000),
    borderColor: Color(0xFFFFB000),
    enableGlow: true,
    glowRadius: 2.0,
    fontFamily: 'Courier New',
    fontSize: 14.0,
  );

  static const TerminalTheme hackerDark = TerminalTheme(
    backgroundColor: Color(0xFF0D1117),
    foregroundColor: Color(0xFF58A6FF),
    cursorColor: Color(0xFF58A6FF),
    borderColor: Color(0xFF21262D),
    errorColor: Color(0xFFFF7B72),
    successColor: Color(0xFF7EE787),
    warningColor: Color(0xFFE3B341),
    fontFamily: 'Fira Code',
    fontSize: 13.0,
    borderRadius: 8.0,
  );

  static const TerminalTheme matrix = TerminalTheme(
    backgroundColor: Color(0xFF000000),
    foregroundColor: Color(0xFF00FF41),
    cursorColor: Color(0xFF00FF41),
    borderColor: Color(0xFF00FF41),
    enableGlow: true,
    enableScanlines: true,
    glowRadius: 4.0,
    fontFamily: 'Courier New',
    fontSize: 12.0,
  );

  static const TerminalTheme retro = TerminalTheme(
    backgroundColor: Color(0xFF2E2E2E),
    foregroundColor: Color(0xFFFFFFFF),
    cursorColor: Color(0xFFFFFFFF),
    borderColor: Color(0xFF666666),
    fontFamily: 'Courier New',
    fontSize: 14.0,
    borderRadius: 0.0,
  );

  static const TerminalTheme neon = TerminalTheme(
    backgroundColor: Color(0xFF000014),
    foregroundColor: Color(0xFFFF00FF),
    cursorColor: Color(0xFFFF00FF),
    borderColor: Color(0xFFFF00FF),
    enableGlow: true,
    glowRadius: 5.0,
    fontFamily: 'Courier New',
    fontSize: 14.0,
  );

  static const TerminalTheme vintage = TerminalTheme(
    backgroundColor: Color(0xFF1A1A00),
    foregroundColor: Color(0xFFFFFF99),
    cursorColor: Color(0xFFFFFF99),
    borderColor: Color(0xFF666633),
    fontFamily: 'Courier New',
    fontSize: 14.0,
    enableScanlines: true,
  );

  static const TerminalTheme modern = TerminalTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Color(0xFFD4D4D4),
    cursorColor: Color(0xFFD4D4D4),
    borderColor: Color(0xFF3E3E42),
    errorColor: Color(0xFFF44747),
    successColor: Color(0xFF4EC9B0),
    warningColor: Color(0xFFFFCC02),
    fontFamily: 'Cascadia Code',
    fontSize: 13.0,
    borderRadius: 6.0,
  );

  static List<TerminalTheme> get allThemes => [
    crtGreen,
    amber,
    hackerDark,
    matrix,
    retro,
    neon,
    vintage,
    modern,
  ];
}