import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MySecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'No data found!';
    print('Data read from secure storage: $value');
    return value;
  }

  deleteSecureData(String key) async {
    await storage.delete(key: key);
  }

  refreshToken() async {
    String oldToken = await readSecureData('accessToken');
  }
}
