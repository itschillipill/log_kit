import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:log_kit/log_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LogKit', () {
    late LogKit logger;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      logger = await LogKit.createLogger(
        storageType: StorageType.sharedPreferences,
      );
    });

    test('log should create and store a debug message', () {
      logger.log('Test debug log', title: 'TestTitle');

      expect(logger.logs.length, 1);
      final entry = logger.logs.first;
      expect(entry.message, 'Test debug log');
      expect(entry.title, 'TestTitle');
      expect(entry.logType, LogType.debug);
    });

    test('warning should create a warning log', () {
      logger.warning('Warning log');
      final entry = logger.logs.last;
      expect(entry.logType, LogType.warning);
    });

    test('error should create an error log', () {
      logger.error('Error occurred');
      final entry = logger.logs.last;
      expect(entry.logType, LogType.error);
    });

    test(
      'saveLogs should persist logs and loadLogs should restore them',
      () async {
        logger.log('Persistent log');
        await logger.saveLogs();

        final newLogger = await LogKit.createLogger(
          storageType: StorageType.sharedPreferences,
        );
        expect(newLogger.logs.length, 1);
        expect(newLogger.logs.first.message, 'Persistent log');
      },
    );

    test('clear should remove all logs and clear storage', () async {
      logger.log('Temp log');
      expect(logger.logs, isNotEmpty);

      await logger.clear();
      expect(logger.logs, isEmpty);
    });

    test('removeLog should remove specific log entry', () async {
      logger.log('Log 1');
      logger.log('Log 2');
      final toRemove = logger.logs.first;

      await logger.removeLog(toRemove);
      expect(logger.logs.any((e) => e.message == 'Log 1'), isFalse);
    });

    test('removeLogByIndex should remove log at index', () async {
      logger.log('First');
      logger.log('Second');

      await logger.removeLogByIndex(0);
      expect(logger.logs.first.message, 'Second');
    });
  });
}
