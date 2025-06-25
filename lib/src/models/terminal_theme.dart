
import 'package:flutter/material.dart';

class TerminalTheme {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color cursorColor;
  final Color selectionColor;
  final Color borderColor;
  final Color errorColor;
  final Color successColor;
  final Color warningColor;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final bool enableScanlines;
  final bool enableGlow;
  final double glowRadius;
  final double borderRadius;
  final double borderWidth;

  const TerminalTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.cursorColor,
    this.selectionColor = const Color(0x4000FF00),
    this.borderColor = const Color(0xFF00FF00),
    this.errorColor = const Color(0xFFFF0000),
    this.successColor = const Color(0xFF00FF00),
    this.warningColor = const Color(0xFFFFFF00),
    this.fontFamily = 'Courier New',
    this.fontSize = 14.0,
    this.lineHeight = 1.2,
    this.enableScanlines = false,
    this.enableGlow = false,
    this.glowRadius = 2.0,
    this.borderRadius = 4.0,
    this.borderWidth = 1.0,
  });

  TerminalTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? cursorColor,
    Color? selectionColor,
    Color? borderColor,
    Color? errorColor,
    Color? successColor,
    Color? warningColor,
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    bool? enableScanlines,
    bool? enableGlow,
    double? glowRadius,
    double? borderRadius,
    double? borderWidth,
  }) {
    return TerminalTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionColor: selectionColor ?? this.selectionColor,
      borderColor: borderColor ?? this.borderColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      enableScanlines: enableScanlines ?? this.enableScanlines,
      enableGlow: enableGlow ?? this.enableGlow,
      glowRadius: glowRadius ?? this.glowRadius,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }
}
