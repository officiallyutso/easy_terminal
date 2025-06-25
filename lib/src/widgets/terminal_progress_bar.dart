import 'package:flutter/material.dart';
import '../models/terminal_theme.dart';
import '../utils/box_drawing.dart';
import 'terminal_text.dart';

class TerminalProgressBar extends StatelessWidget {
  final double progress;
  final String? label;
  final TerminalTheme theme;
  final int width;
  final bool showPercentage;
  final String fillChar;
  final String emptyChar;

  const TerminalProgressBar({
    Key? key,
    required this.progress,
    this.label,
    required this.theme,
    this.width = 40,
    this.showPercentage = true,
    this.fillChar = BoxDrawing.fullBlock,
    this.emptyChar = BoxDrawing.lightShade, required Color color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final fillWidth = (width * clampedProgress).round();
    final emptyWidth = width - fillWidth;
    
    final progressBar = fillChar * fillWidth + emptyChar * emptyWidth;
    final percentage = (clampedProgress * 100).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          TerminalText(
            text: label!,
            theme: theme,
          ),
        Row(
          children: [
            TerminalText(
              text: '[',
              theme: theme,
            ),
            TerminalText(
              text: progressBar,
              theme: theme,
              color: _getProgressColor(clampedProgress),
            ),
            TerminalText(
              text: ']',
              theme: theme,
            ),
            if (showPercentage) ...[
              const SizedBox(width: 8),
              TerminalText(
                text: '$percentage%',
                theme: theme,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return theme.errorColor;
    if (progress < 0.7) return theme.warningColor;
    return theme.successColor;
  }
}