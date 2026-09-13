import 'package:dio/dio.dart';
import 'dart:io';
import '../storage/token_storage.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/io.dart';

class ApiClient {
  late final Dio dio;
  ApiClient() {
    dio = Dio(
      BaseOptions(
        // baseUrl: 'http://127.0.0.1:8000/api',
        // baseUrl: 'http://localhost/api',
        baseUrl: 'https://10.0.2.2/api',
        // baseUrl: 'http://192.168.2.61/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.interceptors.add(AuthInterceptor());
    
  }
}
