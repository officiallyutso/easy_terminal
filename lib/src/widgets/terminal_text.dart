import 'package:flutter/material.dart';
import '../models/terminal_theme.dart';
import '../utils/color_utils.dart';

class TerminalText extends StatelessWidget {
  final String text;
  final TerminalTheme theme;
  final Color? color;
  final bool isInput;
  final bool isBold;
  final TextAlign? textAlign;

  const TerminalText({
    Key? key,
    required this.text,
    required this.theme,
    this.color,
    this.isInput = false,
    this.isBold = false,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? 
        (isInput ? theme.foregroundColor.withOpacity(0.8) : theme.foregroundColor);
    
    return Text(
      text,
      style: TextStyle(
        fontFamily: theme.fontFamily,
        fontSize: theme.fontSize,
        color: textColor,
        height: theme.lineHeight,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        shadows: theme.enableGlow 
            ? ColorUtils.createGlowEffect(textColor, theme.glowRadius)
            : null,
      ),
      textAlign: textAlign,
    );
  }
}