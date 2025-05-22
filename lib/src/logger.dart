import 'log_entry.dart';

abstract class Logger {
  Future<void> loadLogs();
  Future<void> clear();
  Future<void> saveLogs();
  Future<void> removeLog(LogEntry log);
  Future<void> removeLogByIndex(int index);
  void log(String message, {bool save = true, String? title});
  void warning(String message, {bool save = true, String? title});
  void error(String message, {bool save = true, String? title});
  List<LogEntry> get logs;
}
