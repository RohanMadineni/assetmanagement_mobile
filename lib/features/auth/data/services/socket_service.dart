import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification_service.dart';
import '../../../../core/storage/token_storage.dart';
import 'dart:convert';
import '../models/notification_model.dart';

class SocketService extends ChangeNotifier{
  late IO.Socket socket;
  int? userId;
  final NotificationService notificationService;

  SocketService(this.notificationService) { 
    _initialize(); 
  }

  Future<void> _initialize() async{

    final userJson = await TokenStorage.read('user'); 

    if (userJson == null) { 
      print('No user found in storage.'); 
      return; 
    }

    final Map<String, dynamic> user = jsonDecode(userJson);

    userId = int.tryParse(user['id'].toString());

    if (userId == null) { 
      print('No user ID found. Socket.IO will not connect.'); 
      return; 
    }

    socket = IO.io(
      'https://10.0.2.2',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({
            'user_id': userId!.toString(),
          })
          .build(),
    );
    socket.connect();
    socket.onConnect((_) { 
      print('SOCKET CONNECTED'); 
      print('Socket ID: ${socket.id}'); 
      print('SOCKER USER: ${socket.query}');
    });

    socket.on('notification', (data) { 
      print('NOTIFICATION RECEIVED: $data'); 
      final notification = AppNotification.fromJson(Map<String, dynamic>.from(data));
      notificationService.addNotification(notification);
    });
    socket.onConnectError((data) {
      print('SOCKET CONNECT ERROR: $data');
    });

    socket.onError((data) {
      print('SOCKET ERROR: $data');
    });

    socket.onDisconnect((data) {
      print('SOCKET DISCONNECTED: $data');
    });

  }
  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}