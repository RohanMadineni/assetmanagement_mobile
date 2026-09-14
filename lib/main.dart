import 'dart:io';
import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/dashboard_page.dart';
import 'features/auth/presentation/pages/asset-list.dart';
import 'features/auth/presentation/pages/system-dashboard_page.dart';
import 'features/auth/presentation/pages/available-assets.dart';
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