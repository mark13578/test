import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final List<MenuItem> children;

  MenuItem({
    required this.title,
    required this.icon,
    this.children = const [],
  });
}

class SideBar extends StatefulWidget {
  final int selectedIndex;
  final bool isExpanded;
  final Map<String, bool> menuExpanded;
  final List<MenuItem> menuItems;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onToggleExpanded;
  final ValueChanged<String> onToggleMenuExpanded;

  const SideBar({
    Key? key,
    required this.selectedIndex,
    required this.isExpanded,
    required this.menuExpanded,
    required this.menuItems,
    required this.onDestinationSelected,
    required this.onToggleExpanded,
    required this.onToggleMenuExpanded,
  }) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationRailTheme(
      data: const NavigationRailThemeData(
        selectedIconTheme: IconThemeData(color: Colors.blue, size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.grey, size: 24),
        selectedLabelTextStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: TextStyle(color: Colors.grey),
      ),
      child: NavigationRail(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
        extended: widget.isExpanded,
        destinations: _buildNavigationDestinations(),
      ),
    );
  }

  List<NavigationRailDestination> _buildNavigationDestinations() {
    List<NavigationRailDestination> destinations = [];
    int index = 0; // 追蹤當前項目的索引

    for (var category in widget.menuItems) {
      int currentIndex = index; // 記錄當前第一層的索引
      destinations.add(
        NavigationRailDestination(
          icon: Icon(category.icon),
          selectedIcon: Icon(category.icon, color: Colors.blue),
          label: Text(category.title), // 移除 InkWell，將展開邏輯交給 onDestinationSelected
        ),
      );
      index++; // 第一層項目計數

      if (widget.menuExpanded[category.title] == true) {
        for (var subItem in category.children) {
          destinations.add(
            NavigationRailDestination(
              icon: Padding(
                padding: widget.isExpanded ? const EdgeInsets.only(left: 16.0) : EdgeInsets.zero,
                child: Icon(subItem.icon),
              ),
              selectedIcon: Padding(
                padding: widget.isExpanded ? const EdgeInsets.only(left: 16.0) : EdgeInsets.zero,
                child: Icon(subItem.icon, color: Colors.blue),
              ),
              label: Padding(
                padding: widget.isExpanded ? const EdgeInsets.only(left: 16.0) : EdgeInsets.zero,
                child: Text(subItem.title),
              ),
            ),
          );
          index++; // 第二層項目計數
        }
      }
    }
    return destinations;
  }
}