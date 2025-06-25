import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class TerminalKeyboardHandler {
  final Function(String) onTextInput;
  final Function(LogicalKeyboardKey) onSpecialKey;
  final Function(String) onCommand;

  String _currentInput = '';
  List<String> _history = [];
  int _historyIndex = -1;

  TerminalKeyboardHandler({
    required this.onTextInput,
    required this.onSpecialKey,
    required this.onCommand,
  });

  String get currentInput => _currentInput;
  List<String> get history => List.unmodifiable(_history);

  void handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _handleKeyDown(event);
    }
  }

  void _handleKeyDown(KeyDownEvent event) {
    final key = event.logicalKey;

    // Handle special keys
    if (key == LogicalKeyboardKey.enter) {
      _handleEnter();
      return;
    }

    if (key == LogicalKeyboardKey.backspace) {
      _handleBackspace();
      return;
    }

    if (key == LogicalKeyboardKey.arrowUp) {
      _handleHistoryUp();
      return;
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      _handleHistoryDown();
      return;
    }

    if (key == LogicalKeyboardKey.arrowLeft || 
        key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.home ||
        key == LogicalKeyboardKey.end) {
      onSpecialKey(key);
      return;
    }

    // Handle control combinations
    if (HardwareKeyboard.instance.isControlPressed) {
      _handleControlKey(key);
      return;
    }

    // Handle regular character input
    final character = event.character;
    if (character != null && character.isNotEmpty) {
      _currentInput += character;
      onTextInput(_currentInput);
    }
  }

  void _handleEnter() {
    if (_currentInput.trim().isNotEmpty) {
      _history.add(_currentInput);
      onCommand(_currentInput);
    }
    _currentInput = '';
    _historyIndex = -1;
    onTextInput(_currentInput);
  }

  void _handleBackspace() {
    if (_currentInput.isNotEmpty) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      onTextInput(_currentInput);
    }
  }

  void _handleHistoryUp() {
    if (_history.isNotEmpty) {
      if (_historyIndex == -1) {
        _historyIndex = _history.length - 1;
      } else if (_historyIndex > 0) {
        _historyIndex--;
      }
      _currentInput = _history[_historyIndex];
      onTextInput(_currentInput);
    }
  }

  void _handleHistoryDown() {
    if (_historyIndex != -1) {
      if (_historyIndex < _history.length - 1) {
        _historyIndex++;
        _currentInput = _history[_historyIndex];
      } else {
        _historyIndex = -1;
        _currentInput = '';
      }
      onTextInput(_currentInput);
    }
  }

  void _handleControlKey(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.keyC:
        // Ctrl+C - Clear current input
        _currentInput = '';
        onTextInput(_currentInput);
        break;
      case LogicalKeyboardKey.keyL:
        // Ctrl+L - Clear screen (handled by terminal)
        onSpecialKey(LogicalKeyboardKey.f5); // Use F5 as clear signal
        break;
      case LogicalKeyboardKey.keyD:
        // Ctrl+D - EOF
        onSpecialKey(LogicalKeyboardKey.escape);
        break;
      default:
        onSpecialKey(key);
    }
  }

  void clearHistory() {
    _history.clear();
    _historyIndex = -1;
  }

  void addToHistory(String command) {
    if (command.trim().isNotEmpty && 
        (_history.isEmpty || _history.last != command)) {
      _history.add(command);
    }
  }

  void setInput(String input) {
    _currentInput = input;
    _historyIndex = -1;
    onTextInput(_currentInput);
  }
}