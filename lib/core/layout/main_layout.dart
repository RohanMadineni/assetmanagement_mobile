import 'package:flutter/material.dart';
import 'sidebar.dart';
import '../../features/auth/data/services/Auth_Service.dart';
import '../network/api_client.dart';
import '../../features/auth/data/services/notification_service.dart';
import 'package:assetmanagement_mobile/features/auth/data/services/socket_service.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  const MainLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}
class _MainLayoutState extends State<MainLayout> {
  
    int currentPageIndex = 0;
    bool isSidebarExtended = false;
    Map<String, dynamic>? user;
    String role = "";
    String name = "";
    late final AuthService authService;
    late final NotificationService notificationService;
    late final SocketService socketService;

    @override
    void initState() {
      super.initState(); 
      authService = AuthService(
        ApiClient(),
      );
      notificationService = NotificationService(
        ApiClient(),
      );
      
      setUser();
      socketService = SocketService(notificationService);
      notificationService.loadNotifications();
    }
    Future<void> setUser() async{
      final result = await authService.getRole(); 
      setState(() {
        user = result.data;
        role = user!['role'][0].toUpperCase() + user!['role'].substring(1).toLowerCase();
        name = user!['username'];
      });

    }
    void onTabSelected(int index) async {

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/dashboard');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/assets');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/system');
          break;
        case 3:
          // await authService.logout();          
          Navigator.pushReplacementNamed(context, '/available');
          break;
        case 4:
          await authService.logout();          
          Navigator.pushReplacementNamed(context, '/login');
          break;
        
      }
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          indicatorColor: Colors.amber,
          onDestinationSelected: (index) {
            if(index == 1) {
              _showNotifications();
              return;
            }
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations:  <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: ListenableBuilder(
                listenable: notificationService,
                builder: (context, child) {
                  return Badge(
                    label: Text(
                      notificationService.unreadCount.toString(),
                    ),
                    child: const Icon(Icons.notifications_sharp),
                  );
                },
              ),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Badge(label: Text('2'), child: Icon(Icons.messenger_sharp)),
              label: 'Messages',
            ),
          ],
        ),
        appBar: AppBar(
                      leading: IconButton(
                      icon: Icon(
                        isSidebarExtended
                            ? Icons.menu_open
                            : Icons.menu,
                      ),

                      onPressed: () {
                        setState(() {
                          isSidebarExtended = !isSidebarExtended;
                        });
                      },
                    ),
                      title: Text('Asset System', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
                      backgroundColor: const Color.fromARGB(255, 99, 122, 250),
                      foregroundColor: Colors.white38,
                      actions: [
                        Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white24,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text("$role:  $name", style: TextStyle(color: Colors.white)),
                          ],
                          ),
                        ),
                      ],
                    ),
          body: Row(
            
            children: [
              
              Sidebar(
                selectedIndex: widget.selectedIndex,
                onSelect: onTabSelected,
                role: role,
                extended: isSidebarExtended,
              ),

              Expanded(
                child: Column(
                  children: [

                    Expanded(
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ],
        ),
      );
    }
    void _showNotifications() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notifications'),
            content: SizedBox(
              width: 400,
              height: 300,
              child: ListView.builder(
                itemCount: notificationService.notifications.length,
                itemBuilder: (context, index) {
                  final notification = notificationService.notifications[index];

                  return ListTile(
                    title: Text(notification.title),
                    subtitle: Text(notification.message),
                    trailing: notification.isRead == 0
                        ? const Icon(Icons.circle, size: 10)
                        : null,
                    onTap: () async {
                      await notificationService
                          .markAsRead(notification.id);

                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    }
    @override
    void dispose() {
      socketService.dispose();
      notificationService.dispose();
      super.dispose();
    }
}

// import 'package:assetmanagement_mobile/core/layout/sidebar.dart';
// import 'package:flutter/material.dart';
// import '../../features/auth/data/services/Auth_Service.dart';
// import '../network/api_client.dart';
// import '../../features/auth/data/services/notification_service.dart';
// import '../../features/auth/presentation/pages/asset-list.dart';
// import '../../features/auth/presentation/pages/available-assets.dart';
// import '../../features/auth/presentation/pages/dashboard_page.dart';
// import '../../features/auth/presentation/pages/system-dashboard_page.dart';
// class MainLayout extends StatefulWidget {

//   final Widget child;
//   final int selectedIndex;
//   const MainLayout({
//     super.key,
//     required this.child,
//     required this.selectedIndex,
//   });
//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {

//   int currentPageIndex = 0;
//   bool isSidebarExtended = false;
//   Map<String, dynamic>? user;
//   String role = "";
//   String name = "";

  
//   late List<Widget> _pages;
//   late final AuthService authService;
//   late final NotificationService notificationService;
//   bool _isInitialized = false;
//   @override
//   void initState() {
//     super.initState(); 
//     authService = AuthService(
//       ApiClient(),
//     );
//     notificationService = NotificationService(
//       ApiClient(),
//     );
    
//     setUser();

//     notificationService.loadNotifications();
//   }

//   Future<void> setUser() async{
//     final result = await authService.getRole(); 
//     setState(() {
//       user = result.data;
//       role = user!['role'][0].toUpperCase() + user!['role'].substring(1).toLowerCase();
//       name = user!['username'];
//       _pages = [
//         Center(child: Text('Home')),
//     Center(child: Text('Search')),
//     Center(child: Text('Profile')),
//       ];
//       _isInitialized = true;
//     });
    
//   }
//   void onTabSelected(int index) async {
//     // widget.selectedIndex = 
//     currentPageIndex = index;
//   }
//   @override
//     Widget build(BuildContext context) {
//       if (!this._isInitialized) {
//         return const Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       }
//       return Scaffold(
//         appBar: AppBar(leading: IconButton(
//                       icon: Icon(
//                         isSidebarExtended
//                             ? Icons.menu_open
//                             : Icons.menu,
//                       ),

//                       onPressed: () {
//                         setState(() {
//                           isSidebarExtended = !isSidebarExtended;
//                         });
//                       },
//                     ),
//                       title: Text('Asset System', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
//                       backgroundColor: const Color.fromARGB(255, 99, 122, 250),
//                       foregroundColor: Colors.white38,
//                       actions: [
//                         Padding(
//                         padding: const EdgeInsets.only(right: 16),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             CircleAvatar(
//                               radius: 16,
//                               backgroundColor: Colors.white24,
//                               child: const Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Text("$role:  $name", style: TextStyle(color: Colors.white)),
//                           ],
//                           ),
//                         ),
//                       ],),
        
//         body: Row(
//           children: [
//             IndexedStack(
//               index: widget.selectedIndex,
//               children: _pages,
//             ),
//           ],
//         ),
        
//       );
      
//     }
// }