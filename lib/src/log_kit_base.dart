import 'dart:convert';
import 'storage/shared_preferences_storage.dart';
import 'storage/storage_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_trace/stack_trace.dart' show Trace;
import 'log_entry.dart';
import 'logger.dart';
import 'storage/storage.dart';

class LogKit implements Logger {
  final Storage? storage;
  final List<LogEntry> _logs = [];

  LogKit._(this.storage);

  static Future<LogKit> createLogger({
    StorageType? storageType = StorageType.sharedPreferences,
  }) async {
    if (storageType == null) return LogKit._(null);
    switch (storageType) {
      case StorageType.sharedPreferences:
        final prefs = await SharedPreferences.getInstance();
        final logger = LogKit._(SharedPreferencesStorage(prefs));
        await logger.loadLogs();
        return logger;
    }
  }

  factory LogKit.withStorage({required Storage storage}) => LogKit._(storage);

  @override
  void log(String message, {bool save = true, String? title}) {
    _logInternal(message, LogType.debug, save, title);
  }

  @override
  void warning(String message, {bool save = true, String? title}) {
    _logInternal(message, LogType.warning, save, title);
  }

  @override
  void error(String message, {bool save = true, String? title}) {
    _logInternal(message, LogType.error, save, title);
  }

  void _logInternal(String message, LogType type, bool save, String? title) {
    final trace = Trace.current(2);
    final frame = trace.frames.firstWhere(
      (f) => f.package != 'logger',
      orElse: () => trace.frames.first,
    );

    final log = LogEntry(
      title: title,
      message: message,
      logType: type,
      dateTime: DateTime.now(),
      file: '${frame.uri.pathSegments.last}:${frame.line}',
      line: frame.line,
    );

    _logs.add(log);
    _printLog(log);

    if (save) saveLogs();
  }

  void _printLog(LogEntry log) {
    final colorCode = switch (log.logType) {
      LogType.debug => '\x1B[34m',
      LogType.warning => '\x1B[33m',
      LogType.error => '\x1B[31m',
    };
    const reset = '\x1B[0m';
    print('$colorCode$log$reset');
  }

  @override
  List<LogEntry> get logs => List.unmodifiable(_logs);

  @override
  Future<void> loadLogs() async {
    if (storage == null) return;

    try {
      final stored = await storage!.getValue('logs');
      if (stored is String) {
        final List<dynamic> list = jsonDecode(stored);
        _logs.clear();
        _logs.addAll(list.map((e) => LogEntry.fromJson(e)).toList());
      }
    } catch (e) {
      print('Ошибка при загрузке логов: $e');
    }
  }

  @override
  Future<void> saveLogs() async {
    if (storage == null) return;

    try {
      final encoded = jsonEncode(_logs.map((e) => e.toJson()).toList());
      await storage!.setValue('logs', encoded);
    } catch (e) {
      print('Ошибка при сохранении логов: $e');
    }
  }

  @override
  Future<void> removeLog(LogEntry log) async {
    _logs.remove(log);
    await saveLogs();
  }

  @override
  Future<void> removeLogByIndex(int index) async {
    _logs.removeAt(index);
    await saveLogs();
  }

  @override
  Future<void> clear() async {
    _logs.clear();
    await storage?.clear();
  }
}
