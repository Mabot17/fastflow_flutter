import 'package:get_storage/get_storage.dart';

class StorageService {
  static Future<void> init() async {
    await GetStorage.init();
  }

  final GetStorage _storage = GetStorage();

  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  Future<T?> read<T>(String key) async {
    return await _storage.read<T>(key);
  }

  bool has(String key) {
    return _storage.hasData(key);
  }

  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  Future<void> clear() async {
    await _storage.erase();
  }

  List<String> getAllKeys() {
    return _storage.getKeys().toList();
  }
}
