## 0.0.1

- Initial release of `log_kit`.
- Basic logging API: `log`, `warning`, `error`.
- In-memory log storage.
- Optional persistent storage via `Storage` abstraction.
- Built-in support for `SharedPreferences` via `StorageType.sharedPreferences`.
- Automatic stack trace detection using `stack_trace`.
- Colored console output for different log levels.
- Log persistence and retrieval (`saveLogs`, `loadLogs`, `clear`, `removeLog`, `removeLogByIndex`).
