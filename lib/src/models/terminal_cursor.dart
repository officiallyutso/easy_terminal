class TerminalCursor {
  int row;
  int column;
  bool visible;
  bool blinking;

  TerminalCursor({
    this.row = 0,
    this.column = 0,
    this.visible = true,
    this.blinking = true,
  });

  void moveTo(int newRow, int newColumn) {
    row = newRow;
    column = newColumn;
  }

  void moveBy(int deltaRow, int deltaColumn) {
    row += deltaRow;
    column += deltaColumn;
  }

  TerminalCursor copyWith({
    int? row,
    int? column,
    bool? visible,
    bool? blinking,
  }) {
    return TerminalCursor(
      row: row ?? this.row,
      column: column ?? this.column,
      visible: visible ?? this.visible,
      blinking: blinking ?? this.blinking,
    );
  }
}