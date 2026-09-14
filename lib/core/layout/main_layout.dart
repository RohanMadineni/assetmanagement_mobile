import 'package:flutter/material.dart';
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
    late SocketService socketService;

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

    @override
    Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asset Management',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          ListenableBuilder(
            listenable: notificationService,
            builder: (context, child) {
              final unreadCount = notificationService.unreadCount;
                  // notificationService.notifications
                  //     .where((n) => n.isRead == 0)
                  //     .length;

              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_outlined),

                    if (unreadCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            unreadCount > 99
                                ? '99+'
                                : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: _showNotifications,
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              // User information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Text(
                        name.isNotEmpty
                            ? name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      name.isNotEmpty ? name : 'User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      role,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // ListTile(
              //   title: const Text('System Dashboard'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     onTabSelected(2);
              //   },
              // ),
              ListTile(
                title: const Text('Available Assets'),
                onTap: () {
                  Navigator.pop(context);
                  onTabSelected(3);
                },
              ),
              const Spacer(),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  Navigator.pop(context);

                  await authService.logout();

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/login',
                    );
                  }
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),  
      // Bottom mobile navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Assets',
          ),

          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'System',
          ),
        ],
      ),

      // body: const SizedBox.shrink(),
      body: widget.child, 
    );
    }
}