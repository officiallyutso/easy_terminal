import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/terminal_theme.dart';
import '../utils/keyboard_handler.dart';
import 'terminal_text.dart';

typedef TerminalInputCallback = void Function(String input);
typedef TerminalSubmitCallback = void Function(String input);

class TerminalInput extends StatefulWidget {
  final TerminalTheme theme;
  final String prompt;
  final String? placeholder;
  final TerminalInputCallback? onChanged;
  final TerminalSubmitCallback? onSubmitted;
  final bool autofocus;
  final bool showCursor;
  final Duration cursorBlinkDuration;
  final int maxLength;
  final bool multiline;
  final int maxLines;
  final bool enabled;
  final String initialValue;
  final List<String>? suggestions;
  final bool enableHistory;

  const TerminalInput({
    Key? key,
    required this.theme,
    this.prompt = '\$ ',
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = true,
    this.showCursor = true,
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
    this.maxLength = 1000,
    this.multiline = false,
    this.maxLines = 1,
    this.enabled = true,
    this.initialValue = '',
    this.suggestions,
    this.enableHistory = true,
  }) : super(key: key);

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _cursorController;
  late TerminalKeyboardHandler _keyboardHandler;
  late FocusNode _focusNode;
  
  bool _cursorVisible = true;
  List<String> _filteredSuggestions = [];
  int _selectedSuggestionIndex = -1;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    
    _keyboardHandler = TerminalKeyboardHandler(
      onTextInput: _handleTextInput,
      onSpecialKey: _handleSpecialKey,
      onCommand: _handleCommand,
    );
    
    _cursorController = AnimationController(
      duration: widget.cursorBlinkDuration,
      vsync: this,
    );
    
    if (widget.showCursor) {
      _cursorController.repeat(reverse: true);
    }
    
    _cursorController.addListener(() {
      if (mounted) {
        setState(() {
          _cursorVisible = _cursorController.value > 0.5;
        });
      }
    });
    
    _controller.addListener(_onTextChanged);
    
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _cursorController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    
    widget.onChanged?.call(text);
    
    // Update suggestions
    if (widget.suggestions != null && widget.suggestions!.isNotEmpty) {
      _updateSuggestions(text);
    }
    
    setState(() {});
  }

  void _updateSuggestions(String input) {
    if (input.isEmpty) {
      _filteredSuggestions.clear();
      _showSuggestions = false;
      _selectedSuggestionIndex = -1;
      return;
    }
    
    _filteredSuggestions = widget.suggestions!
        .where((suggestion) => suggestion.toLowerCase().startsWith(input.toLowerCase()))
        .take(5)
        .toList();
    
    _showSuggestions = _filteredSuggestions.isNotEmpty;
    _selectedSuggestionIndex = _showSuggestions ? 0 : -1;
  }

  void _handleTextInput(String input) {
    if (!widget.enabled) return;
    
    if (widget.maxLength > 0 && _controller.text.length >= widget.maxLength) {
      return;
    }
    
    // This is handled by the TextEditingController
    // Just update cursor position tracking
    setState(() {
    });
  }

  void _handleSpecialKey(LogicalKeyboardKey key) {
    if (!widget.enabled) return;
    
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        if (_showSuggestions && _selectedSuggestionIndex > 0) {
          setState(() {
            _selectedSuggestionIndex--;
          });
        }
        break;
      case LogicalKeyboardKey.arrowDown:
        if (_showSuggestions && _selectedSuggestionIndex < _filteredSuggestions.length - 1) {
          setState(() {
            _selectedSuggestionIndex++;
          });
        }
        break;
      case LogicalKeyboardKey.tab:
        if (_showSuggestions && _selectedSuggestionIndex >= 0) {
          _applySuggestion(_filteredSuggestions[_selectedSuggestionIndex]);
        }
        break;
      case LogicalKeyboardKey.escape:
        setState(() {
          _showSuggestions = false;
          _selectedSuggestionIndex = -1;
        });
        break;
    }
  }

  void _handleCommand(String command) {
    if (!widget.enabled) return;
    
    widget.onSubmitted?.call(command);
    
    if (widget.enableHistory) {
      _keyboardHandler.addToHistory(command);
    }
    
    // Clear input after submission
    _controller.clear();
    setState(() {
      _showSuggestions = false;
      _selectedSuggestionIndex = -1;
    });
  }

  void _applySuggestion(String suggestion) {
    _controller.text = suggestion;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    setState(() {
      _showSuggestions = false;
      _selectedSuggestionIndex = -1;
    });
  }

  void clear() {
    _controller.clear();
    setState(() {
      _showSuggestions = false;
      _selectedSuggestionIndex = -1;
    });
  }

  void setText(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    setState(() {
    });
  }

  String get text => _controller.text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field
        _buildInputField(),
        
        // Suggestions dropdown
        if (_showSuggestions && _filteredSuggestions.isNotEmpty)
          _buildSuggestions(),
      ],
    );
  }

  Widget _buildInputField() {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          // Handle special keys first
          switch (event.logicalKey) {
            case LogicalKeyboardKey.enter:
              if (!widget.multiline || !HardwareKeyboard.instance.isShiftPressed) {
                _handleCommand(_controller.text);
                return KeyEventResult.handled;
              }
              break;
            case LogicalKeyboardKey.arrowUp:
            case LogicalKeyboardKey.arrowDown:
              if (_showSuggestions) {
                _handleSpecialKey(event.logicalKey);
                return KeyEventResult.handled;
              } else if (widget.enableHistory) {
                _keyboardHandler.handleKeyEvent(event);
                final newInput = _keyboardHandler.currentInput;
                if (newInput != _controller.text) {
                  _controller.text = newInput;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: newInput.length),
                  );
                }
                return KeyEventResult.handled;
              }
              break;
            case LogicalKeyboardKey.tab:
              if (_showSuggestions) {
                _handleSpecialKey(event.logicalKey);
                return KeyEventResult.handled;
              }
              break;
            case LogicalKeyboardKey.escape:
              _handleSpecialKey(event.logicalKey);
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: widget.enabled 
                ? widget.theme.backgroundColor 
                : widget.theme.backgroundColor.withOpacity(0.5),
            border: Border.all(
              color: _focusNode.hasFocus 
                  ? widget.theme.cursorColor 
                  : widget.theme.borderColor,
              width: widget.theme.borderWidth,
            ),
            borderRadius: BorderRadius.circular(widget.theme.borderRadius),
          ),
          child: Row(
            children: [
              // Prompt
              if (widget.prompt.isNotEmpty)
                TerminalText(
                  text: widget.prompt,
                  theme: widget.theme,
                  color: widget.theme.cursorColor,
                  isBold: true,
                ),
              
              // Input field
              Expanded(
                child: widget.multiline 
                    ? _buildMultilineInput() 
                    : _buildSingleLineInput(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleLineInput() {
    return Stack(
      children: [
        // Invisible TextField for actual input handling
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          maxLength: widget.maxLength > 0 ? widget.maxLength : null,
          style: TextStyle(
            fontFamily: widget.theme.fontFamily,
            fontSize: widget.theme.fontSize,
            color: Colors.transparent, // Make text invisible
            height: widget.theme.lineHeight,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          cursorColor: Colors.transparent,
          showCursor: false,
        ),
        
        // Custom text rendering
        Positioned.fill(
          child: _buildCustomText(),
        ),
      ],
    );
  }

  Widget _buildMultilineInput() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength > 0 ? widget.maxLength : null,
      style: TextStyle(
        fontFamily: widget.theme.fontFamily,
        fontSize: widget.theme.fontSize,
        color: widget.theme.foregroundColor,
        height: widget.theme.lineHeight,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        counterText: '',
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          fontFamily: widget.theme.fontFamily,
          fontSize: widget.theme.fontSize,
          color: widget.theme.foregroundColor.withOpacity(0.5),
          height: widget.theme.lineHeight,
        ),
      ),
      cursorColor: widget.theme.cursorColor,
    );
  }

  Widget _buildCustomText() {
    final text = _controller.text;
    final placeholder = widget.placeholder ?? '';
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text content
        if (text.isNotEmpty)
          TerminalText(
            text: text,
            theme: widget.theme,
          )
        else if (placeholder.isNotEmpty)
          TerminalText(
            text: placeholder,
            theme: widget.theme,
            color: widget.theme.foregroundColor.withOpacity(0.5),
          ),
        
        // Cursor
        if (widget.showCursor && _cursorVisible && _focusNode.hasFocus)
          TerminalText(
            text: '█',
            theme: widget.theme,
            color: widget.theme.cursorColor,
          ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      decoration: BoxDecoration(
        color: widget.theme.backgroundColor,
        border: Border.all(
          color: widget.theme.borderColor,
          width: widget.theme.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
      ),
      child: Column(
        children: _filteredSuggestions.asMap().entries.map((entry) {
          final index = entry.key;
          final suggestion = entry.value;
          final isSelected = index == _selectedSuggestionIndex;
          
          return GestureDetector(
            onTap: () => _applySuggestion(suggestion),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              color: isSelected 
                  ? widget.theme.selectionColor 
                  : Colors.transparent,
              child: TerminalText(
                text: suggestion,
                theme: widget.theme,
                color: isSelected ? widget.theme.cursorColor : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}