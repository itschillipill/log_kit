import 'package:flutter_log_kit/log_kit.dart';

/// In-memory implementation of the Storage interface.
/// This is useful for testing and examples without external dependencies.
class InMemoryStorage implements Storage {
  final Map<String, dynamic> _store = {};

  @override
  Future<void> setValue<T>(String key, T value) async {
    _store[key] = value;
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final value = _store[key];
    if (value is T) return value;
    return null;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}

Future<void> main() async {
  // Create a logger with in-memory storage
  final logger = LogKit.withStorage(storage: InMemoryStorage());

  // Log messages with different severity levels
  logger.log('Simple debug message');
  logger.warning('A warning message');
  logger.error('An error occurred', title: 'Execution Error');

  print('\nCurrent logs:');
  for (final log in logger.logs) {
    print(
      '- ${log.dateTime.toIso8601String()} [${log.logType}] ${log.message}',
    );
  }

  print('\nSaving logs...');
  await logger.saveLogs();

  print('Clearing logs from memory...');
  await logger.clear();

  print('Logs after clearing: ${logger.logs.length}'); // should be 0

  print('Reloading logs...');
  await logger.loadLogs();

  print('Restored logs:');
  for (final log in logger.logs) {
    print(
      '- ${log.dateTime.toIso8601String()} [${log.logType}] ${log.message}',
    );
  }
}
