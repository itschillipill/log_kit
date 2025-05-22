abstract class Storage {
  Future<void> setValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
