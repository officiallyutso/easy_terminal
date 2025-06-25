import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/terminal_theme.dart';
import 'terminal_text.dart';

typedef TerminalInputCallback = void Function(String value);
typedef TerminalInputValidator = String? Function(String value);

class TerminalInput extends StatefulWidget {
  final String prompt;
  final String? initialValue;
  final TerminalInputCallback? onChanged;
  final TerminalInputCallback? onSubmitted;
  final TerminalInputValidator? validator;
  final TerminalTheme theme;
  final bool obscureText;
  final String obscureCharacter;
  final bool autofocus;
  final int? maxLength;
  final bool showCursor;
  final Duration cursorBlinkDuration;

  const TerminalInput({
    Key? key,
    this.prompt = '> ',
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    required this.theme,
    this.obscureText = false,
    this.obscureCharacter = '*',
    this.autofocus = true,
    this.maxLength,
    this.showCursor = true,
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _cursorController;
  final FocusNode _focusNode = FocusNode();
  
  bool _cursorVisible = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _controller.addListener(_handleTextChange);
    
    _cursorController = AnimationController(
      duration: widget.cursorBlinkDuration,
      vsync: this,
    );
    
    if (widget.showCursor) {
      _cursorController.repeat(reverse: true);
    }
    
    _cursorController.addListener(() {
      setState(() {
        _cursorVisible = _cursorController.value > 0.5;
      });
    });
    
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

  void _handleTextChange() {
    final value = _controller.text;
    
    // Validate input
    if (widget.validator != null) {
      setState(() {
        _errorMessage = widget.validator!(value);
      });
    }
    
    widget.onChanged?.call(value);
  }

  void _handleSubmit() {
    final value = _controller.text;
    
    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) {
        setState(() {
          _errorMessage = error;
        });
        return;
      }
    }
    
    widget.onSubmitted?.call(value);
  }

  String _getDisplayText() {
    final text = _controller.text;
    if (widget.obscureText) {
      return widget.obscureCharacter * text.length;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          focusNode: _focusNode,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
              _handleSubmit();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            onTap: () => _focusNode.requestFocus(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: widget.theme.backgroundColor,
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
                  TerminalText(
                    text: widget.prompt,
                    theme: widget.theme,
                    color: widget.theme.cursorColor,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        // Hidden TextField for actual input handling
                        Opacity(
                          opacity: 0.0,
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            style: TextStyle(
                              fontFamily: widget.theme.fontFamily,
                              fontSize: widget.theme.fontSize,
                              color: Colors.transparent,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            maxLength: widget.maxLength,
                            obscureText: false, // We handle obscuring manually
                            onSubmitted: (value) => _handleSubmit(),
                          ),
                        ),
                        // Visible text display
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TerminalText(
                                  text: _getDisplayText(),
                                  theme: widget.theme,
                                ),
                                if (widget.showCursor && _focusNode.hasFocus)
                                  AnimatedOpacity(
                                    opacity: _cursorVisible ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 50),
                                    child: TerminalText(
                                      text: '█',
                                      theme: widget.theme,
                                      color: widget.theme.cursorColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: TerminalText(
              text: _errorMessage!,
              theme: widget.theme,
              color: widget.theme.errorColor,
            ),
          ),
      ],
    );
  }
}