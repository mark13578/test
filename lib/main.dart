import 'package:flutter/material.dart';
import 'components/side_bar.dart';

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
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
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
  int _selectedIndex = 0;
  bool _isExpanded = true;
  String _currentPath = "";
  Map<String, int>? _lastSelectedSubItem;

  void _updatePath(String parentTitle, String? childTitle) {
    setState(() {
      _currentPath = childTitle != null ? "$parentTitle > $childTitle" : "";
    });
  }

  Map<String, bool> _menuExpanded = {
    "系統管理": false,
    "工單管理": false,
    "虛擬機作業": false,
    "財務管理": false,
  };

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
      "title": "虛擬機作業",
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

  final List<String> _pageTitles = [
    "系統管理",
    "本人帳號",
    "他人帳號",
    "企業組織管理",
    "角色分配",
    "組織權限分配",
    "資產管理",
    "公告管理",
    "系統日誌",
    "工單管理",
    "建立工單",
    "虛擬機作業",
    "虛擬機",
    "虛擬機操作",
    "虛擬機管理",
    "財務管理",
    "月結帳單管理",
    "成本核算",
    "其他進項管理",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SideBar(
                selectedIndex: _selectedIndex,
                isExpanded: _isExpanded,
                menuExpanded: _menuExpanded,
                menuItems: _menuItems,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;

                    int count = 0;
                    bool found = false;

                    for (var category in _menuItems) {
                      if (count == index) {
                        // 點擊第一層項目，清除路徑和第二層記錄
                        _currentPath = "";
                        _lastSelectedSubItem = null;
                        found = true;
                        break;
                      }
                      count++;

                      if (category["children"] != null && _menuExpanded[category["title"]]!) {
                        for (var subItem in category["children"]) {
                          if (count == index) {
                            // 點擊第二層項目，更新路徑和記錄
                            _currentPath = "${category["title"]} > ${subItem["title"]}";
                            _lastSelectedSubItem = {
                              "parent": _menuItems.indexOf(category),
                              "child": category["children"].indexOf(subItem),
                            };
                            found = true;
                            break;
                          }
                          count++;
                        }
                      }
                      if (found) break;
                    }
                  });
                },
                onToggleExpanded: () {
                  setState(() {
                    if (_isExpanded) {
                      // 縮合時
                      if (_lastSelectedSubItem != null) {
                        _selectedIndex = _lastSelectedSubItem!["parent"]!;
                        _currentPath = "";
                      }
                      _menuExpanded.updateAll((key, value) => false);
                    } else {
                      // 展開時
                      if (_lastSelectedSubItem != null) {
                        String parentTitle = _menuItems[_lastSelectedSubItem!["parent"]!]["title"];
                        _menuExpanded[parentTitle] = true;
                        int parentIndex = _lastSelectedSubItem!["parent"]!;
                        int childOffset = _lastSelectedSubItem!["child"]!;
                        _selectedIndex = parentIndex + 1 + childOffset;
                        _currentPath = "$parentTitle > ${_menuItems[parentIndex]["children"][childOffset]["title"]}";
                      }
                    }
                    _isExpanded = !_isExpanded;
                  });
                },
                onToggleMenuExpanded: (title) {
                  setState(() {
                    _menuExpanded[title] = !_menuExpanded[title]!;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentPath.isNotEmpty)
                        Text(
                          _currentPath,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        _pageTitles[_selectedIndex],
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text('內容區域', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}