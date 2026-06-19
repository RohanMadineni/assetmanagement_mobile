import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
class ApiClient {
  late final Dio dio;
  ApiClient() {
    dio = Dio(
      BaseOptions(
        // baseUrl: 'http://127.0.0.1:8000/api',
        baseUrl: 'http://localhost/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(AuthInterceptor());
    
  }
}
