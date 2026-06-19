import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String role;
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('My Assets'),
        ),
        if (role == 'Admin')
        NavigationRailDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: Text('System Dashboard'),
        ),
        if (role == 'Admin')
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('Available Assets'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.logout_outlined),
          selectedIcon: Icon(Icons.logout),
          label: Text('Logout'),
        ),
      ],
    );
  }
}