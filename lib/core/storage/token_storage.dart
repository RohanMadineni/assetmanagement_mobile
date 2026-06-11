import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
class TokenStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> save(
    String key,
    String value,
  ) async {
    await storage.write(
      key: key,
      value: value,
    );
  }

  static Future<String?> read(
    String key,
  ) async {
    return storage.read(key: key);
  }

  static Future<void> clear() async{
    await storage.deleteAll();
  }
  static Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }
}

class AuthInterceptor extends Interceptor {
  // final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler,) async {
    // final token = await _secureStorage.read(key: 'auth_token');
    final token = await TokenStorage.getToken();
    // print("TOKEN = $token");
    // Add the token to headers if it exists
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    // print(options.headers);
    handler.next(options);
  }
}