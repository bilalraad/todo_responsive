import 'package:hive/hive.dart';

class DataBase {
  DataBase(String boxName) {
    _boxName = boxName;
  }
  String _boxName;

  /// If [defaultValue] is specified, it is returned in case the key does not
  /// exist.
  Future<T> getDataFromBox<T>(String key, {T defaultValue}) async {
    try {
      final _box = await Hive.openBox(_boxName);
      final value = _box.get(key, defaultValue: defaultValue);
      // _box.close();
      return value;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> putDataIntoBox<T>(
    String key,
    T value,
  ) async {
    try {
      final _box = await Hive.openBox(_boxName);
      await _box.put(key, value);
      _box.close();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeDataFromBox<T>(String key) async {
    try {
      final _box = await Hive.openBox(_boxName);
      _box.delete(key);
      _box.close();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<T>> getAllDataFromBox<T>() async {
    try {
      final _box = await Hive.openBox(_boxName);
      final value = _box.values.toList();
      _box.close();
      return value;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
