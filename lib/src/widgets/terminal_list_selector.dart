import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/terminal_theme.dart';
import '../utils/box_drawing.dart';
import 'terminal_text.dart';

typedef TerminalListCallback<T> = void Function(T item, int index);

class TerminalListSelector<T> extends StatefulWidget {
  final List<T> items;
  final TerminalListCallback<T>? onSelected;
  final String Function(T)? itemBuilder;
  final TerminalTheme theme;
  final String title;
  final bool showBorder;
  final bool showNumbers;
  final String selectedIndicator;
  final String unselectedIndicator;
  final int? maxHeight;
  final bool autofocus;

  const TerminalListSelector({
    Key? key,
    required this.items,
    this.onSelected,
    this.itemBuilder,
    required this.theme,
    this.title = 'Select an option:',
    this.showBorder = true,
    this.showNumbers = true,
    this.selectedIndicator = '▶ ',
    this.unselectedIndicator = '  ',
    this.maxHeight,
    this.autofocus = true,
  }) : super(key: key);

  @override
  State<TerminalListSelector<T>> createState() => _TerminalListSelectorState<T>();
}

class _TerminalListSelectorState<T> extends State<TerminalListSelector<T>> {
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          _moveSelection(-1);
          break;
        case LogicalKeyboardKey.arrowDown:
          _moveSelection(1);
          break;
        case LogicalKeyboardKey.enter:
        case LogicalKeyboardKey.space:
          _selectCurrent();
          break;
        case LogicalKeyboardKey.home:
          _moveToIndex(0);
          break;
        case LogicalKeyboardKey.end:
          _moveToIndex(widget.items.length - 1);
          break;
      }
    }
  }

  void _moveSelection(int delta) {
    setState(() {
      _selectedIndex = (_selectedIndex + delta).clamp(0, widget.items.length - 1);
    });
    _scrollToSelected();
  }

  void _moveToIndex(int index) {
    setState(() {
      _selectedIndex = index.clamp(0, widget.items.length - 1);
    });
    _scrollToSelected();
  }

  void _selectCurrent() {
    if (_selectedIndex >= 0 && _selectedIndex < widget.items.length) {
      widget.onSelected?.call(widget.items[_selectedIndex], _selectedIndex);
    }
  }

  void _scrollToSelected() {
    if (_scrollController.hasClients) {
      final itemHeight = widget.theme.fontSize * widget.theme.lineHeight + 4;
      final targetOffset = _selectedIndex * itemHeight;
      
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  String _getItemText(T item) {
    return widget.itemBuilder?.call(item) ?? item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          decoration: widget.showBorder
              ? BoxDecoration(
                  border: Border.all(
                    color: widget.theme.borderColor,
                    width: widget.theme.borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(widget.theme.borderRadius),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title.isNotEmpty) _buildTitle(),
              _buildItemList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TerminalText(
        text: widget.title,
        theme: widget.theme,
        isBold: true,
      ),
    );
  }

  Widget _buildItemList() {
    final maxHeight = widget.maxHeight?.toDouble();
    
    return Container(
      height: maxHeight,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final isSelected = index == _selectedIndex;
          final indicator = isSelected 
              ? widget.selectedIndicator 
              : widget.unselectedIndicator;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              _selectCurrent();
            },
            child: Container(
              color: isSelected 
                  ? widget.theme.selectionColor 
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Row(
                children: [
                  TerminalText(
                    text: indicator,
                    theme: widget.theme,
                    color: isSelected ? widget.theme.cursorColor : null,
                  ),
                  if (widget.showNumbers) ...[
                    TerminalText(
                      text: '${index + 1}. ',
                      theme: widget.theme,
                      color: widget.theme.foregroundColor.withOpacity(0.7),
                    ),
                  ],
                  Expanded(
                    child: TerminalText(
                      text: _getItemText(item),
                      theme: widget.theme,
                      color: isSelected ? widget.theme.cursorColor : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}