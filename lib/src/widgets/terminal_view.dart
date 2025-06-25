import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/terminal_theme.dart';
import '../models/terminal_buffer.dart';
import '../models/terminal_command.dart';
import '../utils/keyboard_handler.dart';
import '../utils/color_utils.dart';
import 'terminal_text.dart';

typedef TerminalCommandCallback = void Function(TerminalCommand command);
typedef TerminalTextCallback = void Function(String text);

class TerminalView extends StatefulWidget {
  final TerminalTheme theme;
  final TerminalCommandCallback? onCommand;
  final TerminalTextCallback? onTextInput;
  final String prompt;
  final bool autofocus;
  final int maxLines;
  final double width;
  final double height;
  final List<String>? initialText;
  final bool showCursor;
  final Duration cursorBlinkDuration;

  const TerminalView({
    Key? key,
    required this.theme,
    this.onCommand,
    this.onTextInput,
    this.prompt = '\$ ',
    this.autofocus = true,
    this.maxLines = 1000,
    this.width = double.infinity,
    this.height = 400,
    this.initialText,
    this.showCursor = true,
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView>
    with TickerProviderStateMixin {
  late TerminalBuffer _buffer;
  late TerminalKeyboardHandler _keyboardHandler;
  late AnimationController _cursorController;
  late ScrollController _scrollController;
  
  final FocusNode _focusNode = FocusNode();
  String _currentInput = '';
  bool _cursorVisible = true;

  @override
  void initState() {
    super.initState();
    
    _buffer = TerminalBuffer(maxLines: widget.maxLines);
    _scrollController = ScrollController();
    
    // Initialize with initial text
    if (widget.initialText != null) {
      for (final text in widget.initialText!) {
        _buffer.addText(text);
      }
    }
    
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
    _cursorController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextInput(String input) {
    setState(() {
      _currentInput = input;
    });
    widget.onTextInput?.call(input);
    _scrollToBottom();
  }

  void _handleSpecialKey(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.f5) {
      // Clear screen
      setState(() {
        _buffer.clear();
      });
    }
  }

  void _handleCommand(String commandString) {
    final command = TerminalCommand.parse(commandString);
    
    // Add command to buffer
    _buffer.addLine(TerminalLine(
      content: '${widget.prompt}$commandString',
      isInput: true,
    ));
    
    setState(() {
      _currentInput = '';
    });
    
    widget.onCommand?.call(command);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void addOutput(String text, {Color? color}) {
    setState(() {
      _buffer.addText(text, color: color);
    });
    _scrollToBottom();
  }

  void clearScreen() {
    setState(() {
      _buffer.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.theme.backgroundColor,
        border: Border.all(
          color: widget.theme.borderColor,
          width: widget.theme.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
        boxShadow: widget.theme.enableGlow
            ? [
                BoxShadow(
                  color: widget.theme.foregroundColor.withOpacity(0.3),
                  blurRadius: widget.theme.glowRadius,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: (node, event) {
          _keyboardHandler.handleKeyEvent(event);
          return KeyEventResult.handled;
        },
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Stack(
            children: [
              // Scanlines effect
              if (widget.theme.enableScanlines) _buildScanlines(),
              
              // Terminal content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Terminal output
                    Expanded(
                      child: _buildTerminalOutput(),
                    ),
                    
                    // Current input line
                    _buildInputLine(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanlines() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: List.generate(20, (index) {
              return index.isEven
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.05);
            }),
            stops: List.generate(20, (index) => index / 19),
          ),
        ),
      ),
    );
  }

  Widget _buildTerminalOutput() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _buffer.length,
      itemBuilder: (context, index) {
        final line = _buffer.lines[index];
        return TerminalText(
          text: line.content,
          theme: widget.theme,
          color: line.color,
          isInput: line.isInput,
        );
      },
    );
  }

  Widget _buildInputLine() {
    return Row(
      children: [
        TerminalText(
          text: widget.prompt,
          theme: widget.theme,
        ),
        Expanded(
          child: TerminalText(
            text: _currentInput,
            theme: widget.theme,
          ),
        ),
        if (widget.showCursor && _cursorVisible)
          TerminalText(
            text: '█',
            theme: widget.theme,
            color: widget.theme.cursorColor,
          ),
      ],
    );
  }
}
