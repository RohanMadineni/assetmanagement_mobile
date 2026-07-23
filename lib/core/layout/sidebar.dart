import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String role;
  final bool extended;
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.role,
    required this.extended,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  width: extended ? 220 : 72,
      
    child: NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      // labelType: NavigationRailLabelType.all,
      // This controls whether labels are visible
      extended: extended,

      // Makes the rail width more predictable
      labelType: NavigationRailLabelType.none,
      // minWidth: 72,
      // minExtendedWidth: 220,
      

      // labelType: extended
      //     ? NavigationRailLabelType.none
      //     : NavigationRailLabelType.all,
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
    ),);
  }
}