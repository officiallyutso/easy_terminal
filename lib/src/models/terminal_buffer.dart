import 'package:flutter/material.dart';

class TerminalLine {
  final String content;
  final Color? color;
  final bool isInput;
  final DateTime timestamp;

  TerminalLine({
    required this.content,
    this.color,
    this.isInput = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  TerminalLine copyWith({
    String? content,
    Color? color,
    bool? isInput,
    DateTime? timestamp,
  }) {
    return TerminalLine(
      content: content ?? this.content,
      color: color ?? this.color,
      isInput: isInput ?? this.isInput,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class TerminalBuffer {
  final List<TerminalLine> _lines = [];
  final int maxLines;
  int _scrollOffset = 0;

  TerminalBuffer({this.maxLines = 1000});

  List<TerminalLine> get lines => List.unmodifiable(_lines);
  int get length => _lines.length;
  int get scrollOffset => _scrollOffset;

  void addLine(TerminalLine line) {
    _lines.add(line);
    if (_lines.length > maxLines) {
      _lines.removeAt(0);
    }
    _scrollOffset = 0; // Reset scroll when new content is added
  }

  void addText(String text, {Color? color, bool isInput = false}) {
    final lines = text.split('\n');
    for (final line in lines) {
      addLine(TerminalLine(
        content: line,
        color: color,
        isInput: isInput,
      ));
    }
  }

  void clear() {
    _lines.clear();
    _scrollOffset = 0;
  }

  void scroll(int delta) {
    _scrollOffset = (_scrollOffset + delta).clamp(0, _lines.length - 1);
  }

  List<TerminalLine> getVisibleLines(int screenHeight) {
    final startIndex = (_lines.length - screenHeight - _scrollOffset).clamp(0, _lines.length);
    final endIndex = (_lines.length - _scrollOffset).clamp(0, _lines.length);
    return _lines.sublist(startIndex, endIndex);
  }
}
