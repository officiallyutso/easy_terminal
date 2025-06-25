import 'package:flutter/material.dart';
import 'package:easy_terminal/easy_terminal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Terminal Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: const TerminalDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TerminalDemoPage extends StatefulWidget {
  const TerminalDemoPage({Key? key}) : super(key: key);

  @override
  State<TerminalDemoPage> createState() => _TerminalDemoPageState();
}

class _TerminalDemoPageState extends State<TerminalDemoPage> {
  final GlobalKey<TerminalViewState> _terminalKey = GlobalKey();
  late TerminalTheme _currentTheme;
  int _selectedThemeIndex = 0;
  
  final List<String> _availableCommands = [
    'help', 'clear', 'ls', 'pwd', 'cd', 'cat', 'echo', 'date', 'whoami', 'uname',
    'ps', 'kill', 'mkdir', 'rmdir', 'touch', 'rm', 'cp', 'mv', 'grep', 'find',
    'chmod', 'chown', 'tar', 'zip', 'unzip', 'wget', 'curl', 'ping', 'ssh',
    'scp', 'git', 'npm', 'node', 'python', 'pip', 'java', 'javac', 'gcc',
    'make', 'docker', 'kubectl',
  ];

  @override
  void initState() {
    super.initState();
    _currentTheme = TerminalThemes.crtGreen;
  }

  void _handleCommand(TerminalCommand command) {
    final terminalState = _terminalKey.currentState;
    if (terminalState == null) return;

    switch (command.command.toLowerCase()) {
      case 'help':
        terminalState.addOutput('''
Available commands:
  help          - Show this help message
  clear         - Clear the terminal screen
  theme <name>  - Change terminal theme
  themes        - List available themes
  demo          - Run terminal components demo
  progress      - Show progress bar demo
  list          - Show list selector demo
  panel         - Show panel demo
  echo <text>   - Echo text back
  date          - Show current date and time
  whoami        - Show current user
  pwd           - Show current directory
  ls            - List directory contents
  uname         - Show system information
  cowsay <text> - Make a cow say something
  matrix        - Enter the matrix
  figlet <text> - ASCII art text
''', color: _currentTheme.successColor);
        break;

      case 'clear':
        terminalState.clearScreen();
        break;

      case 'theme':
        if (command.args.isNotEmpty) {
          _changeTheme(command.args[0]);
        } else {
          terminalState.addOutput('Usage: theme <name>', color: _currentTheme.errorColor);
          terminalState.addOutput('Available themes: ${TerminalThemes.allThemes.map((t) => _getThemeName(t)).join(', ')}');
        }
        break;

      case 'themes':
        terminalState.addOutput('Available themes:');
        for (int i = 0; i < TerminalThemes.allThemes.length; i++) {
          final themeName = _getThemeName(TerminalThemes.allThemes[i]);
          final current = i == _selectedThemeIndex ? ' (current)' : '';
          terminalState.addOutput('  ${i + 1}. $themeName$current');
        }
        break;

      case 'demo':
        _showComponentsDemo();
        break;

      case 'progress':
        _showProgressDemo();
        break;

      case 'list':
        _showListDemo();
        break;

      case 'panel':
        _showPanelDemo();
        break;

      case 'echo':
        if (command.args.isNotEmpty) {
          terminalState.addOutput(command.args.join(' '));
        } else {
          terminalState.addOutput('');
        }
        break;

      case 'date':
        final now = DateTime.now();
        terminalState.addOutput(now.toString());
        break;

      case 'whoami':
        terminalState.addOutput('terminal_user');
        break;

      case 'pwd':
        terminalState.addOutput('/home/terminal_user');
        break;

      case 'ls':
        terminalState.addOutput('''
total 42
drwxr-xr-x  2 user user  4096 ${DateTime.now().toString().substring(0, 16)} .
drwxr-xr-x  3 user user  4096 ${DateTime.now().toString().substring(0, 16)} ..
-rw-r--r--  1 user user   220 ${DateTime.now().toString().substring(0, 16)} .bash_logout
-rw-r--r--  1 user user  3771 ${DateTime.now().toString().substring(0, 16)} .bashrc
-rw-r--r--  1 user user   807 ${DateTime.now().toString().substring(0, 16)} .profile
-rw-r--r--  1 user user  1024 ${DateTime.now().toString().substring(0, 16)} document.txt
-rwxr-xr-x  1 user user  2048 ${DateTime.now().toString().substring(0, 16)} script.sh
''');
        break;

      case 'uname':
        terminalState.addOutput('Linux terminal-demo 5.15.0 #1 SMP x86_64 GNU/Linux');
        break;

      case 'cowsay':
        final text = command.args.isEmpty ? 'Hello, Terminal!' : command.args.join(' ');
        final cow = _generateCowsay(text);
        terminalState.addOutput(cow, color: _currentTheme.successColor);
        break;

      case 'matrix':
        _runMatrixEffect();
        break;

      case 'figlet':
        final text = command.args.isEmpty ? 'TERMINAL' : command.args.join(' ');
        final ascii = _generateFiglet(text);
        terminalState.addOutput(ascii, color: _currentTheme.cursorColor);
        break;

      default:
        if (command.command.isNotEmpty) {
          terminalState.addOutput(
            'Command not found: ${command.command}. Type "help" for available commands.',
            color: _currentTheme.errorColor,
          );
        }
    }
  }

  String _getThemeName(TerminalTheme theme) {
    if (theme == TerminalThemes.crtGreen) return 'crt-green';
    if (theme == TerminalThemes.amber) return 'amber';
    if (theme == TerminalThemes.hackerDark) return 'hacker-dark';
    if (theme == TerminalThemes.matrix) return 'matrix';
    if (theme == TerminalThemes.retro) return 'retro';
    if (theme == TerminalThemes.neon) return 'neon';
    if (theme == TerminalThemes.vintage) return 'vintage';
    if (theme == TerminalThemes.modern) return 'modern';
    return 'unknown';
  }

  void _changeTheme(String themeName) {
    final terminalState = _terminalKey.currentState;
    if (terminalState == null) return;

    int newIndex = -1;
    TerminalTheme? newTheme;

    switch (themeName.toLowerCase()) {
      case 'crt-green':
        newTheme = TerminalThemes.crtGreen;
        newIndex = 0;
        break;
      case 'amber':
        newTheme = TerminalThemes.amber;
        newIndex = 1;
        break;
      case 'hacker-dark':
        newTheme = TerminalThemes.hackerDark;
        newIndex = 2;
        break;
      case 'matrix':
        newTheme = TerminalThemes.matrix;
        newIndex = 3;
        break;
      case 'retro':
        newTheme = TerminalThemes.retro;
        newIndex = 4;
        break;
      case 'neon':
        newTheme = TerminalThemes.neon;
        newIndex = 5;
        break;
      case 'vintage':
        newTheme = TerminalThemes.vintage;
        newIndex = 6;
        break;
      case 'modern':
        newTheme = TerminalThemes.modern;
        newIndex = 7;
        break;
    }

    if (newTheme != null) {
      setState(() {
        _currentTheme = newTheme!;
        _selectedThemeIndex = newIndex;
      });
      terminalState.addOutput('Theme changed to: $themeName', color: _currentTheme.successColor);
    } else {
      terminalState.addOutput('Unknown theme: $themeName', color: _currentTheme.errorColor);
    }
  }

  void _showComponentsDemo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600,
          height: 500,
          child: TerminalPanel(
            title: 'Terminal Components Demo',
            theme: _currentTheme,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TerminalText(
                          text: 'Welcome to Easy Terminal Components!',
                          theme: _currentTheme,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        TerminalText(
                          text: 'This package provides various terminal-style widgets:',
                          theme: _currentTheme,
                        ),
                        const SizedBox(height: 8),
                        TerminalText(
                          text: '• TerminalView - Full terminal emulator',
                          theme: _currentTheme,
                        ),
                        TerminalText(
                          text: '• TerminalInput - Command input field',
                          theme: _currentTheme,
                        ),
                        TerminalText(
                          text: '• TerminalPanel - Bordered container',
                          theme: _currentTheme,
                        ),
                        TerminalText(
                          text: '• TerminalProgressBar - ASCII progress bars',
                          theme: _currentTheme,
                        ),
                        TerminalText(
                          text: '• TerminalListSelector - Interactive lists',
                          theme: _currentTheme,
                        ),
                        const SizedBox(height: 16),
                        TerminalProgressBar(
                          progress: 0.75,
                          label: 'Demo Progress',
                          theme: _currentTheme,
                          color: _currentTheme.successColor,
                        ),
                        const SizedBox(height: 16),
                        TerminalText(
                          text: 'Try different themes using: theme <name>',
                          theme: _currentTheme,
                          color: _currentTheme.warningColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: TerminalText(
                        text: 'Close',
                        theme: _currentTheme,
                        color: _currentTheme.cursorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProgressDemo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          height: 300,
          child: TerminalPanel(
            title: 'Progress Bar Demo',
            theme: _currentTheme,
            child: Column(
              children: [
                TerminalProgressBar(
                  progress: 0.25,
                  label: 'Loading...',
                  theme: _currentTheme,
                  color: _currentTheme.errorColor,
                ),
                const SizedBox(height: 16),
                TerminalProgressBar(
                  progress: 0.60,
                  label: 'Processing...',
                  theme: _currentTheme,
                  color: _currentTheme.warningColor,
                ),
                const SizedBox(height: 16),
                TerminalProgressBar(
                  progress: 0.90,
                  label: 'Almost Done...',
                  theme: _currentTheme,
                  color: _currentTheme.successColor,
                ),
                const SizedBox(height: 16),
                TerminalProgressBar(
                  progress: 1.0,
                  label: 'Complete!',
                  theme: _currentTheme,
                  showPercentage: true,
                  color: _currentTheme.successColor,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: TerminalText(
                        text: 'Close',
                        theme: _currentTheme,
                        color: _currentTheme.cursorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showListDemo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          height: 400,
          child: TerminalPanel(
            title: 'List Selector Demo',
            theme: _currentTheme,
            child: TerminalListSelector<String>(
              items: ['Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 5'],
              theme: _currentTheme,
              title: 'Select an option:',
              onSelected: (item, index) {
                Navigator.of(context).pop();
                _terminalKey.currentState?.addOutput(
                  'Selected: $item (index: $index)',
                  color: _currentTheme.successColor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showPanelDemo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          height: 350,
          child: TerminalPanel(
            title: 'Panel Demo',
            theme: _currentTheme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TerminalText(
                  text: 'This is a TerminalPanel widget!',
                  theme: _currentTheme,
                  isBold: true,
                ),
                const SizedBox(height: 16),
                TerminalText(
                  text: 'Panels can contain any widget and provide a terminal-style border.',
                  theme: _currentTheme,
                ),
                const SizedBox(height: 16),
                TerminalText(
                  text: 'Features:',
                  theme: _currentTheme,
                  color: _currentTheme.warningColor,
                ),
                TerminalText(
                  text: '• Customizable title bar',
                  theme: _currentTheme,
                ),
                TerminalText(
                  text: '• Theme-aware styling',
                  theme: _currentTheme,
                ),
                TerminalText(
                  text: '• Flexible content area',
                  theme: _currentTheme,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: TerminalText(
                        text: 'Close',
                        theme: _currentTheme,
                        color: _currentTheme.cursorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _generateCowsay(String text) {
    final lines = text.split('\n');
    final maxLength = lines.fold(0, (max, line) => line.length > max ? line.length : max);
    final topBorder = ' ' + '_' * (maxLength + 2);
    final bottomBorder = ' ' + '-' * (maxLength + 2);
    
    String result = topBorder + '\n';
    for (final line in lines) {
      result += '< ${line.padRight(maxLength)} >\n';
    }
    result += bottomBorder + '\n';
    result += '''
        \\   ^__^
         \\  (oo)\\_______
            (__)\\       )\\/\\
                ||----w |
                ||     ||''';
    
    return result;
  }

  String _generateFiglet(String text) {
    // Simple ASCII art generator
    final Map<String, List<String>> chars = {
      'A': ['  ██  ', ' ████ ', '██  ██', '██████', '██  ██'],
      'B': ['██████', '██  ██', '██████', '██████', '██████'],
      'C': [' █████', '██    ', '██    ', '██    ', ' █████'],
      'D': ['██████', '██  ██', '██  ██', '██  ██', '██████'],
      'E': ['██████', '██    ', '█████ ', '██    ', '██████'],
      'F': ['██████', '██    ', '█████ ', '██    ', '██    '],
      'G': [' █████', '██    ', '██ ███', '██  ██', ' █████'],
      'H': ['██  ██', '██  ██', '██████', '██  ██', '██  ██'],
      'I': ['██████', '  ██  ', '  ██  ', '  ██  ', '██████'],
      'J': ['██████', '    ██', '    ██', '██  ██', ' █████'],
      'K': ['██  ██', '██ ██ ', '████  ', '██ ██ ', '██  ██'],
      'L': ['██    ', '██    ', '██    ', '██    ', '██████'],
      'M': ['██████', '██████', '██  ██', '██  ██', '██  ██'],
      'N': ['██  ██', '███ ██', '██████', '██ ███', '██  ██'],
      'O': [' █████', '██  ██', '██  ██', '██  ██', ' █████'],
      'P': ['██████', '██  ██', '██████', '██    ', '██    '],
      'Q': [' █████', '██  ██', '██  ██', '██ ███', ' ██████'],
      'R': ['██████', '██  ██', '██████', '██ ██ ', '██  ██'],
      'S': [' █████', '██    ', ' █████', '    ██', '██████'],
      'T': ['██████', '  ██  ', '  ██  ', '  ██  ', '  ██  '],
      'U': ['██  ██', '██  ██', '██  ██', '██  ██', ' █████'],
      'V': ['██  ██', '██  ██', '██  ██', ' ████ ', '  ██  '],
      'W': ['██  ██', '██  ██', '██  ██', '██████', '██████'],
      'X': ['██  ██', ' ████ ', '  ██  ', ' ████ ', '██  ██'],
      'Y': ['██  ██', ' ████ ', '  ██  ', '  ██  ', '  ██  '],
      'Z': ['██████', '   ██ ', '  ██  ', ' ██   ', '██████'],
      ' ': ['      ', '      ', '      ', '      ', '      '],
    };
    
    final lines = List.generate(5, (_) => '');
    for (final char in text.toUpperCase().split('')) {
      final charLines = chars[char] ?? chars[' ']!;
      for (int i = 0; i < 5; i++) {
        lines[i] += charLines[i];
      }
    }
    
    return lines.join('\n');
  }

  void _runMatrixEffect() {
    final terminalState = _terminalKey.currentState;
    if (terminalState == null) return;
    
    terminalState.addOutput('Entering the Matrix...', color: _currentTheme.successColor);
    
    // Simulate matrix effect with random characters
    final chars = '0123456789ABCDEF';
    for (int i = 0; i < 10; i++) {
      String line = '';
      for (int j = 0; j < 60; j++) {
        line += chars[(DateTime.now().millisecondsSinceEpoch + i + j) % chars.length];
      }
      terminalState.addOutput(line, color: _currentTheme.successColor);
    }
    
    terminalState.addOutput('Matrix effect complete.', color: _currentTheme.successColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Terminal Demo'),
        backgroundColor: _currentTheme.backgroundColor,
        foregroundColor: _currentTheme.foregroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TerminalView(
          key: _terminalKey,
          theme: _currentTheme,
          onCommand: _handleCommand,
          prompt: 'demo\$ ',
          initialText: [
            'Welcome to Easy Terminal Demo!',
            'Type "help" to see available commands.',
            '',
          ],
        ),
      ),
    );
  }
}