enum LogType { debug, warning, error }

class LogEntry {
  final String? title;
  final String message;
  final LogType logType;
  final DateTime dateTime;
  final String? file;
  final int? line;

  LogEntry({
    this.title,
    required this.message,
    required this.logType,
    required this.dateTime,
    this.file,
    this.line,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'logType': logType.name,
    'dateTime': dateTime.toIso8601String(),
    'file': file,
    'line': line,
  };

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
    title: json['title'],
    message: json['message'],
    logType: LogType.values.firstWhere((e) => e.name == json['logType']),
    dateTime: DateTime.parse(json['dateTime']),
    file: json['file'],
    line: json['line'],
  );

  @override
  String toString() =>
      '${title != null ? "$title || " : ""}${logType.name.toUpperCase()} [$dateTime] (${file ?? "unknown"}): $message';
}
