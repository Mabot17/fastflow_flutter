import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  void write(String key, dynamic value) {
    _storage.write(key, value);
  }

  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  bool has(String key) {
    return _storage.hasData(key);
  }

  void remove(String key) {
    _storage.remove(key);
  }
}
