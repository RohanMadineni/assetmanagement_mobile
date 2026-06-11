import 'package:assetmanagement_mobile/core/network/api_client.dart';
import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

class NotificationService extends ChangeNotifier{
  final ApiClient apiClient;
  NotificationService(this.apiClient){
    loadNotifications();
  }

  List<AppNotification> notifications = [];
   
   Future<void> loadNotifications() async {
    final response =
        await apiClient.dio.get('/notifications');

    notifications =
        (response.data as List)
            .map((e) => AppNotification.fromJson(e))
            .toList();

    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    await apiClient.dio.put(
      '/notifications/$id',
    );

    final index =
        notifications.indexWhere((n) => n.id == id);

    if (index != -1) {
      notifications[index] = AppNotification(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        type: notifications[index].type,
        isRead: 1,
        createdAt: notifications[index].createdAt,
      );
    }

    notifyListeners();
  }

  int get unreadCount =>
      notifications.where((n) => n.isRead == 0).length;
}