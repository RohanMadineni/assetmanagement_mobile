import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification_service.dart';
import '../../../../core/storage/token_storage.dart';
import 'dart:convert';
import '../models/notification_model.dart';
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

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
            'user_id': userId.toString(),
          })
          .build(),
    );
    
    socket.onConnect((_) { 
      print('SOCKET CONNECTED'); 
      print('Socket ID: ${socket.id}'); 
    });

    socket.on('notification', (data) { 
      print('NOTIFICATION RECEIVED: $data'); 
      final notification = AppNotification.fromJson(Map<String, dynamic>.from(data));
      print('4. AFTER fromJson');
      print('5. NOTIFICATION: $notification');
      notificationService.addNotification(notification);
      print('6. AFTER addNotification');
      // notificationService.notifyListeners();
    });

    socket.connect();
  }
  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
//   void connect(int userId) {
//     socket = IO.io(
//       'http://10.0.2.2',
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .setQuery({
//             'user_id': userId.toString(),
//           })
//           .build(),
//     );

//     socket.onConnect((_) {
//       print('Connected ${socket.id}');
//     });

//     socket.on('notification', (data) {
//       print(data);

//       final notification =
//           AppNotification.fromJson(data);

//       notificationService.notifications.insert(
//         0,
//         notification,
//       );
      
//       notificationService.notifyListeners();
//     });
//   }


// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'notification_service.dart';
// import '../models/notification_model.dart';

// class SocketService extends ChangeNotifier {
//   final IO.Socket socket;
//   final NotificationService notificationService;

//   SocketService({
//     required this.socket,
//     required this.notificationService,
//   });

//   void connect(int userId) {
//     final options = socket.io.options ?? <String, dynamic>{};

//     options['query'] = {
//         'user_id': userId.toString(),
//     };

//     socket.onConnect((_) {
//       print('SOCKET CONNECTED');
//       print('Socket ID: ${socket.id}');
//     });

//     socket.onConnectError((error) {
//       print('SOCKET CONNECT ERROR: $error');
//     });

//     socket.onError((error) {
//       print('SOCKET ERROR: $error');
//     });

//     socket.onDisconnect((reason) {
//       print('SOCKET DISCONNECTED: $reason');
//     });

//     socket.on('notification', (body) {
//       print('NOTIFICATION RECEIVED: $body');

//       try {
//         final notification = AppNotification.fromJson(
//           Map<String, dynamic>.from(body),
//         );

//         notificationService.notifications.insert(
//           0,
//           notification,
//         );

//         notificationService.notifyListeners();

//         print('Notification added successfully');
//       } catch (e) {
//         print('Failed to process notification: $e');
//       }
//     });

//     socket.connect();
//   }

//   void disconnect() {
//     socket.disconnect();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:socket_io' as IO;
// import 'notification_service.dart';
// import '../models/notification_model.dart';
// class SocketService extends ChangeNotifier{
//     static final SocketService _instance = 
// }