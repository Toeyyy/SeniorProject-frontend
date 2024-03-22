import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MySecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, dynamic value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'No data found!';
    return value;
  }

  deleteSecureData(String key) async {
    await storage.delete(key: key);
  }

  refreshToken() async {
    String expireDate = await readSecureData('tokenExpires');
    DateTime formattedExpire = DateTime(
      int.parse(
        expireDate.substring(0, 4),
      ),
      int.parse(
        expireDate.substring(5, 7),
      ),
      int.parse(
        expireDate.substring(8, 10),
      ),
      int.parse(
            expireDate.substring(11, 13),
          ) +
          7,
      int.parse(
        expireDate.substring(14, 16),
      ),
      int.parse(
        expireDate.substring(17, 19),
      ),
    );
    DateTime currentDate = DateTime.now();
    if (currentDate.isAtSameMomentAs(formattedExpire) ||
        currentDate.isAfter(formattedExpire)) {
      String oldToken = await readSecureData('accessToken');
      String refreshToken = await readSecureData('refreshToken');
      var data = {
        "accessToken": oldToken,
        "refreshToken": refreshToken,
      };
      final http.Response response = await http.post(
        Uri.parse("${dotenv.env['API_PATH']}/refresh-token"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
        },
        body: jsonEncode(data),
      );
      if ((response.statusCode >= 200 && response.statusCode < 300)) {
        print("Posting complete");
        dynamic jsonFile = jsonDecode(response.body);
        await MySecureStorage()
            .writeSecureData('accessToken', jsonFile['accessToken']);
        await MySecureStorage()
            .writeSecureData('refreshToken', jsonFile['refreshToken']);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    }
  }
}
