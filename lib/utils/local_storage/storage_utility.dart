import 'package:get_storage/get_storage.dart';

class AppLocalStorage {

  late final GetStorage _storage;

  static AppLocalStorage? _instance;

  AppLocalStorage._internal();

  factory AppLocalStorage.instance() {
    _instance ??= AppLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = AppLocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }

  Future<void> writeData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }
}
