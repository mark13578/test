import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '管理系統',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue, // Material 3 配色
        useMaterial3: true, // 啟用 Material 3
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 當前選擇的索引
  bool _isExpanded = true; // 是否展開
  Map<String, bool> _menuExpanded = {
    "系統管理": true,
    "工單管理": true,
    "虛擬機操作": true,
    "財務管理": true,
  };

  // 📌 定義選單結構
  final List<Map<String, dynamic>> _menuItems = [
    {
      "title": "系統管理",
      "icon": Icons.settings,
      "children": [
        {"title": " 本人帳號", "icon": Icons.account_circle_outlined},
        {"title": " 他人帳號", "icon": Icons.people_alt_outlined},
        {"title": " 企業組織管理", "icon": Icons.business_outlined},
        {"title": " 角色分配", "icon": Icons.admin_panel_settings_outlined},
        {"title": " 組織權限分配", "icon": Icons.security_outlined},
        {"title": " 資產管理", "icon": Icons.inventory_outlined},
        {"title": " 公告管理", "icon": Icons.announcement_outlined},
        {"title": " 系統日誌", "icon": Icons.receipt_long_outlined},
      ]
    },
    {
      "title": "工單管理",
      "icon": Icons.description_outlined,
      "children": [
        {"title": " 建立工單", "icon": Icons.note_add_outlined},
      ]
    },
    {
      "title": "虛擬機操作",
      "icon": Icons.computer,
      "children": [
        {"title": " 虛擬機", "icon": Icons.computer_outlined},
        {"title": " 虛擬機操作", "icon": Icons.settings_applications_outlined},
        {"title": " 虛擬機管理", "icon": Icons.dashboard_outlined},
      ]
    },
    {
      "title": "財務管理",
      "icon": Icons.attach_money,
      "children": [
        {"title": " 月結帳單管理", "icon": Icons.receipt_outlined},
        {"title": " 成本核算", "icon": Icons.calculate_outlined},
        {"title": " 其他進項管理", "icon": Icons.attach_money_outlined},
      ]
    },
  ];

  // 📌 定義對應的標題
  final List<String> _pageTitles = [
    "本人帳號",
    "他人帳號",
    "企業組織管理",
    "角色分配",
    "組織權限分配",
    "資產管理",
    "公告管理",
    "系統日誌",
    "建立工單",
    "虛擬機",
    "虛擬機操作",
    "虛擬機管理",
    "月結帳單管理",
    "成本核算",
    "其他進項管理",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 📌 可收合的側邊選單
          NavigationRailTheme(
            data: NavigationRailThemeData(
              selectedIconTheme: IconThemeData(color: Colors.blue, size: 30),
              unselectedIconTheme: IconThemeData(color: Colors.grey, size: 24),
              selectedLabelTextStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              unselectedLabelTextStyle: TextStyle(color: Colors.grey),
            ),
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: _isExpanded, // 控制展開/縮小
              leading: IconButton(
                icon: Icon(_isExpanded ? Icons.menu_open : Icons.menu),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              destinations: _buildNavigationDestinations(),
            ),
          ),
          // 📌 主要內容區（標題靠左上角）
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // 設置內邊距
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 讓標題靠左對齊
                children: [
                  Text(
                    _pageTitles[_selectedIndex], // 根據當前索引顯示標題
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16), // 間距
                  Expanded(
                    child: Center(child: Text('內容區域', style: TextStyle(fontSize: 24))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 動態建立選單
  List<NavigationRailDestination> _buildNavigationDestinations() {
    List<NavigationRailDestination> destinations = [];

    for (var category in _menuItems) {
      // 第一層選單（大分類）
      destinations.add(
        NavigationRailDestination(
          icon: Icon(category["icon"]),
          selectedIcon: Icon(category["icon"], color: Colors.blue),
          label: InkWell(
            onTap: () {
              setState(() {
                _menuExpanded[category["title"]] = !_menuExpanded[category["title"]]!;
              });
            },
            child: Text(category["title"]),
          ),
        ),
      );

      // 如果展開，則顯示第二層選單
      if (_menuExpanded[category["title"]] == true) {
        for (var subItem in category["children"]) {
          destinations.add(
            NavigationRailDestination(
              icon: Icon(subItem["icon"]),
              selectedIcon: Icon(subItem["icon"], color: Colors.blue),
              label: Text(subItem["title"]),
            ),
          );
        }
      }
    }
    return destinations;
  }
}
