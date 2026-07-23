import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification_service.dart';
import '../models/notification_model.dart';
class SocketService extends ChangeNotifier{
  late IO.Socket socket;

  final NotificationService notificationService;

  SocketService(this.notificationService);

  void connect(int userId) {
    socket = IO.io(
      'http://localhost',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({
            'user_id': userId.toString(),
          })
          .build(),
    );

    socket.onConnect((_) {
      print('Connected');
    });

    socket.on('notification', (data) {
      print(data);

      final notification =
          AppNotification.fromJson(data);

      notificationService.notifications.insert(
        0,
        notification,
      );
      
      notificationService.notifyListeners();
    });
  }
}