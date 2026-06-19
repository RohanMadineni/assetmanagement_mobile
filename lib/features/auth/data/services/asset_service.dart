import 'package:assetmanagement_mobile/core/network/api_client.dart';
import 'package:dio/dio.dart';
class AssetService {
  final ApiClient apiClient;

  AssetService(this.apiClient);

  Future<Response> getStats() async {
    final response = await apiClient.dio.get('/assets/stats');
    return response;
  }
  Future<Response> getAllStats() async {
    final response = await apiClient.dio.get('/assets/allstats');
    return response;
  }
  Future<dynamic> getUpcomingAssets() async {
    final response = await apiClient.dio.get('/assets/warranty/upcoming');
    return response;
  }
  Future<dynamic> getAllUpcomingAssets() async {
    final response = await apiClient.dio.get('/assets/allwarranty/upcoming');
    return response;
  }
  Future<dynamic> getRecentlyAssignedAssets() async {
    final response = await apiClient.dio.get('/assets/recentlyAssigned');
    return response;
  }
  Future<dynamic> getAllRecentlyAssignedAssets() async {
    final response = await apiClient.dio.get('/assets/allrecentlyAssigned');
    return response;
  }
  Future<Response> getAssets() async {
    final response = await apiClient.dio.get('/assets');
    return response;
  }
  Future<Response> getAllAssets() async {
    final response = await apiClient.dio.get('/assets/all');
    return response;
  }
}