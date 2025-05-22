# 📦 flutter_log_kit

A lightweight, extensible logging package for Dart and Flutter projects.

Supports:
- Different log levels: `debug`, `warning`, `error`
- Colored console output
- Optional persistent storage (e.g., `SharedPreferences`, in-memory, or custom)
- Stack trace and source file context
- Easily pluggable into CLI or Flutter environments

---

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  log_kit:
    git:
      url: https://github.com/itschillipill/log_kit.git
```

---

## 🛠️ Usage

### 1. `createLogger()` — for Flutter/SharedPreferences

This method uses `SharedPreferencesStorage` under the hood. Suitable for persistent logging in apps.

```dart
import 'package:flutter_log_kit/log_kit.dart';

Future<void> main() async {
  final logger = await LogKit.createLogger();

  logger.log('Log from createLogger');
  logger.warning('This is a warning');
  logger.error('Something went wrong!', title: 'FatalError');

  await logger.saveLogs();

  for (final entry in logger.logs) {
    print('- [${entry.logType}] ${entry.message}');
  }
}
```

> ⚠️ This version depends on `shared_preferences`, which internally relies on `dart:ui`.  
> It **won't work** in pure Dart environments (e.g., `dart test`, command-line apps).

---

### 2. `withStorage()` — for Dart CLI, tests, or custom storage

You can inject your own `Storage` implementation, e.g. for unit tests or non-Flutter apps.

#### Example with in-memory storage:
```dart
import 'package:flutter_log_kit/log_kit.dart';

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
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();
}

Future<void> main() async {
  final logger = LogKit.withStorage(storage: InMemoryStorage());

  logger.log('CLI debug message');
  logger.warning('This is a warning');
  logger.error('Something went wrong');

  await logger.saveLogs();

  print('Current logs:');
  for (final log in logger.logs) {
    print('- ${log.message}');
  }
}
```

---

## 📂 Storage Interface

Define your own storage by implementing the `Storage` interface:

```dart
abstract class Storage {
  Future<void> setValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
```

---

## 🧪 Running tests

In environments that **don't support Flutter**, use `withStorage()` and a mock or in-memory storage for test compatibility.

```bash
dart test
```

Make sure your tests avoid using `SharedPreferencesStorage` directly.

---

## 📌 TODO

- [ ] File-based logging
- [ ] SQLite/Isar backends
- [ ] Filters, search, export

---

## 📄 License

MIT © 2025 `Chillipill`