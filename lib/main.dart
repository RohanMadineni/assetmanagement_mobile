import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/dashboard_page.dart';
import 'features/auth/presentation/pages/asset-list.dart';
import 'features/auth/presentation/pages/system-dashboard_page.dart';
import 'features/auth/presentation/pages/available-assets.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(MainApp(apiClient: ApiClient()),);
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
