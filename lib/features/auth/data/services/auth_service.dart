import 'dart:convert';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<Response> login({required String username, required String password}) async {
    final response = await apiClient.dio.post('/auth/login', data: {"username": username, "password" : password});
    await _saveSession(response.data);
    // print(await TokenStorage.getToken());
    return response;
  }
  Future<void> logout() async {
    await apiClient.dio.post('/auth/logout');
  }
  Future<void> _saveSession(
    Map<String, dynamic> authResult,
  ) async {
    
    await TokenStorage.save(
      'token',
      authResult['authorisation']['token'],
    );

    await TokenStorage.save(
      'expiresAt',
      DateTime.now()
          .add(
            Duration(
              seconds: authResult['authorisation']['expires_in'],
            ),
          )
          .millisecondsSinceEpoch
          .toString(),
    );
    await TokenStorage.save(
      'user',
      jsonEncode(authResult['user']),
    );
  } 
  Future<Response> getRole() async{
    final response = await ApiClient().dio.get('/auth/role');
    return response;
  }
  // Future<void> getHttp() async {
  
  //   await apiClient.getHttp();
  // } 
}