import 'dart:io';
import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/dashboard_page.dart';
import 'features/auth/presentation/pages/asset-list.dart';
import 'features/auth/presentation/pages/system-dashboard_page.dart';
import 'features/auth/presentation/pages/available-assets.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // IO.Socket socket = IO.io('http://10.0.2.2',
  //   <String, dynamic>{
  //   'transports': ['websocket'],
  //   'autoConnect': true,
  // },);
  // socket.onConnect((_) {
  //   print('SOCKET CONNECTION ESTABLISHED ${socket.id}');
  // });

  // socket.onConnectError((error) {
  //   print('SOCKET CONNECT ERROR: $error');
  // });

  // socket.onError((error) {
  //   print('SOCKET ERROR: $error');
  // });

  // socket.onDisconnect((reason) {
  //   print('SOCKET DISCONNECTED: $reason');
  // });

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/assets': (context) => const AssetListPage(),
        '/system': (context) => const SystemDashboardPage(),
        '/available' :(context) => const AvailableAssetListPage(),
      }, 
    )
  );
}



// class MainApp extends StatelessWidget {
//   final ApiClient apiClient;
//   const MainApp({super.key, required this.apiClient});
//   Future<dynamic> loadAssets() async {
//     try{
//     final response = await apiClient.dio.get('/assets/allstats');
//     return response.data;
//     } catch(e){
//       print(e);
//       rethrow;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: FutureBuilder(
//           future: loadAssets(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (snapshot.hasError) {
//               return Center(
//                 child: Text(snapshot.error.toString()),
//               );
//             }

//             return Center(
//               child: Text(snapshot.data.toString()),
//             );
//           },
//         ),
//       ),
      
//     );
//   }
// }


// import 'dart:io';

// import 'package:assetmanagement_mobile/core/network/api_client.dart';
// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'features/auth/presentation/pages/login_page.dart';
// import 'features/auth/presentation/pages/dashboard_page.dart';
// import 'features/auth/presentation/pages/asset-list.dart';
// import 'features/auth/presentation/pages/system-dashboard_page.dart';
// import 'features/auth/presentation/pages/available-assets.dart';

// import 'features/auth/data/services/socket_service.dart';
// import 'features/auth/data/services/notification_service.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
// final ApiClient apiClient = ApiClient();
//   // DEVELOPMENT ONLY:
//   // Accept the local/self-signed HTTPS certificate used by Nginx.
//   HttpOverrides.global = MyHttpOverrides();

//   // Create ONE Socket.IO instance.
//   //
//   // Nginx is exposing HTTPS on port 443 and forwarding
//   // /socket.io/ to realtime-server:3000.
//   final IO.Socket socket = IO.io(
//     'http://10.0.2.2:3000/',
//     <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     },
//   );

//   // Create your notification service.
//   final NotificationService notificationService =
//       NotificationService(apiClient);

//   // Pass the socket instance into SocketService.
//   final SocketService socketService = SocketService(
//     socket: socket,
//     notificationService: notificationService,
//   );

//   runApp(
//     MyApp(
//       socketService: socketService,
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   final SocketService socketService;

//   const MyApp({
//     super.key,
//     required this.socketService,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,

//       initialRoute: '/login',

//       routes: {
//         '/login': (context) => const LoginPage(),

//         '/dashboard': (context) => const DashboardPage(),

//         '/assets': (context) => const AssetListPage(),

//         '/system': (context) => const SystemDashboardPage(),

//         '/available': (context) =>
//             const AvailableAssetListPage(),
//       },
//     );
//   }
// }

