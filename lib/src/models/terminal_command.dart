class TerminalCommand {
  final String command;
  final List<String> args;
  final Map<String, String> flags;
  final DateTime timestamp;

  TerminalCommand({
    required this.command,
    this.args = const [],
    this.flags = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory TerminalCommand.parse(String input) {
    final parts = input.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return TerminalCommand(command: '');

    final command = parts.first;
    final args = <String>[];
    final flags = <String, String>{};

    for (int i = 1; i < parts.length; i++) {
      final part = parts[i];
      if (part.startsWith('--')) {
        final flagParts = part.substring(2).split('=');
        flags[flagParts[0]] = flagParts.length > 1 ? flagParts[1] : 'true';
      } else if (part.startsWith('-')) {
        flags[part.substring(1)] = 'true';
      } else {
        args.add(part);
      }
    }

    return TerminalCommand(
      command: command,
      args: args,
      flags: flags,
    );
  }

  @override
  String toString() => '$command ${args.join(' ')}';
}
