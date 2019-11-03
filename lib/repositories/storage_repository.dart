import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  final SharedPreferences sharedPreferences;

  StorageRepository({@required this.sharedPreferences}) : assert(sharedPreferences != null);

  Future<bool> setString(String key, String value) {
    return sharedPreferences.setString(key, value);
  }

  String getString(String key) {
    return sharedPreferences.getString(key);
  }

  Future<bool> remove(String key) {
    return sharedPreferences.remove(key);
  }
}
