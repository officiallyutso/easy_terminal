import 'package:flutter/material.dart';

class ColorUtils {
  /// Convert a hex string to a Color
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Convert a Color to a hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Create a glow effect for terminal text
  static List<Shadow> createGlowEffect(Color color, double radius) {
    return [
      Shadow(
        color: color.withOpacity(0.5),
        blurRadius: radius * 2,
        offset: const Offset(0, 0),
      ),
      Shadow(
        color: color.withOpacity(0.3),
        blurRadius: radius * 4,
        offset: const Offset(0, 0),
      ),
    ];
  }

  /// Blend two colors
  static Color blendColors(Color color1, Color color2, double ratio) {
    ratio = ratio.clamp(0.0, 1.0);
    return Color.lerp(color1, color2, ratio) ?? color1;
  }

  /// Darken a color
  static Color darken(Color color, double amount) {
    amount = amount.clamp(0.0, 1.0);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// Lighten a color
  static Color lighten(Color color, double amount) {
    amount = amount.clamp(0.0, 1.0);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Get contrast color (black or white)
  static Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}