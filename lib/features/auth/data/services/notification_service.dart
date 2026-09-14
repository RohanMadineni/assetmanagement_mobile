import 'package:assetmanagement_mobile/core/network/api_client.dart';
import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

class NotificationService extends ChangeNotifier{
  final ApiClient apiClient;

  NotificationService(this.apiClient);
  List<AppNotification> notifications = [];

  void addNotification(AppNotification notification) { 
    print('notification added: ${notification}');
    // if(notification.isRead==0) {
    //   notifications.insert(0, notification);
    //   notifyListeners();
    // } 
    // else {
    //   markAsReadLocally(notification.id);
    // }
    final index = notifications.indexWhere(
      (n)=>n.id == notification.id,
    );

    if (index == -1) {
      notifications.insert(0, notification);
    } else {
      notifications[index] = notification;
    }
    
    notifyListeners();
  }

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

    markAsReadLocally(id);
  }

  void markAsReadLocally(int id) {
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
  int get unreadCount { return notifications.where((notification) => notification.isRead == 0).length; }
}