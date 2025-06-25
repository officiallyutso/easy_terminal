class BoxDrawing {
  // Single line box drawing characters
  static const String topLeft = '┌';
  static const String topRight = '┐';
  static const String bottomLeft = '└';
  static const String bottomRight = '┘';
  static const String horizontal = '─';
  static const String vertical = '│';
  static const String cross = '┼';
  static const String teeUp = '┴';
  static const String teeDown = '┬';
  static const String teeLeft = '┤';
  static const String teeRight = '├';

  // Double line box drawing characters
  static const String dTopLeft = '╔';
  static const String dTopRight = '╗';
  static const String dBottomLeft = '╚';
  static const String dBottomRight = '╝';
  static const String dHorizontal = '═';
  static const String dVertical = '║';
  static const String dCross = '╬';
  static const String dTeeUp = '╩';
  static const String dTeeDown = '╦';
  static const String dTeeLeft = '╣';
  static const String dTeeRight = '╠';

  // Block characters
  static const String fullBlock = '█';
  static const String darkShade = '▓';
  static const String mediumShade = '▒';
  static const String lightShade = '░';
  static const String upperHalfBlock = '▀';
  static const String lowerHalfBlock = '▄';
  static const String leftHalfBlock = '▌';
  static const String rightHalfBlock = '▐';

  // Arrow characters
  static const String arrowUp = '↑';
  static const String arrowDown = '↓';
  static const String arrowLeft = '←';
  static const String arrowRight = '→';

  // Special characters
  static const String bullet = '•';
  static const String diamond = '◆';
  static const String heart = '♥';
  static const String spade = '♠';
  static const String club = '♣';

  static String createBox(int width, int height, {bool doubleLine = false}) {
    if (width < 2 || height < 2) return '';

    final tl = doubleLine ? dTopLeft : topLeft;
    final tr = doubleLine ? dTopRight : topRight;
    final bl = doubleLine ? dBottomLeft : bottomLeft;
    final br = doubleLine ? dBottomRight : bottomRight;
    final h = doubleLine ? dHorizontal : horizontal;
    final v = doubleLine ? dVertical : vertical;

    final lines = <String>[];
    
    // Top line
    lines.add(tl + h * (width - 2) + tr);
    
    // Middle lines
    for (int i = 1; i < height - 1; i++) {
      lines.add(v + ' ' * (width - 2) + v);
    }
    
    // Bottom line
    lines.add(bl + h * (width - 2) + br);
    
    return lines.join('\n');
  }

  static String createHorizontalLine(int width, {bool doubleLine = false}) {
    final h = doubleLine ? dHorizontal : horizontal;
    return h * width;
  }

  static String createVerticalLine(int height, {bool doubleLine = false}) {
    final v = doubleLine ? dVertical : vertical;
    return List.generate(height, (i) => v).join('\n');
  }

  static String createProgressBar(double progress, int width, {
    String fillChar = '█',
    String emptyChar = '░',
    bool showPercentage = true,
  }) {
    progress = progress.clamp(0.0, 1.0);
    final fillWidth = (width * progress).round();
    final emptyWidth = width - fillWidth;
    
    final bar = fillChar * fillWidth + emptyChar * emptyWidth;
    
    if (showPercentage) {
      final percentage = (progress * 100).round();
      return '$bar $percentage%';
    }
    
    return bar;
  }
}