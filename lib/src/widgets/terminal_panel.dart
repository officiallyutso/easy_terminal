import 'package:flutter/material.dart';
import '../models/terminal_theme.dart';
import 'terminal_text.dart';

class TerminalPanel extends StatelessWidget {
  final String? title;
  final Widget child;
  final TerminalTheme theme;
  final bool doubleBorder;
  final EdgeInsets padding;
  final double? width;
  final double? height;

  const TerminalPanel({
    Key? key,
    this.title,
    required this.child,
    required this.theme,
    this.doubleBorder = false,
    this.padding = const EdgeInsets.all(8.0),
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: Border.all(
          color: theme.borderColor,
          width: theme.borderWidth,
        ),
        borderRadius: BorderRadius.circular(theme.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) _buildTitle(),
          Expanded(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.borderColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor,
            width: 1.0,
          ),
        ),
      ),
      child: TerminalText(
        text: title!,
        theme: theme,
        isBold: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}
