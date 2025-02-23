import 'package:flutter/material.dart';
import 'components/side_bar.dart';
import 'components/custom_appbar.dart';

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

  Map<String, bool> _menuExpanded = {
    "系統管理": false,
    "工單管理": false,
    "虛擬機作業": false,
    "財務管理": false,
  };

  final List<MenuItem> _menuItems = [
    MenuItem(
      title: "系統管理",
      icon: Icons.settings,
      children: [
        MenuItem(title: " 本人帳號", icon: Icons.account_circle_outlined),
        MenuItem(title: " 他人帳號", icon: Icons.people_alt_outlined),
        MenuItem(title: " 企業組織管理", icon: Icons.business_outlined),
        MenuItem(title: " 角色分配", icon: Icons.admin_panel_settings_outlined),
        MenuItem(title: " 組織權限分配", icon: Icons.security_outlined),
        MenuItem(title: " 資產管理", icon: Icons.inventory_outlined),
        MenuItem(title: " 公告管理", icon: Icons.announcement_outlined),
        MenuItem(title: " 系統日誌", icon: Icons.receipt_long_outlined),
      ],
    ),
    MenuItem(
      title: "工單管理",
      icon: Icons.description_outlined,
      children: [
        MenuItem(title: " 建立工單", icon: Icons.note_add_outlined),
      ],
    ),
    MenuItem(
      title: "虛擬機作業",
      icon: Icons.computer,
      children: [
        MenuItem(title: " 虛擬機", icon: Icons.computer_outlined),
        MenuItem(title: " 虛擬機操作", icon: Icons.settings_applications_outlined),
        MenuItem(title: " 虛擬機管理", icon: Icons.dashboard_outlined),
      ],
    ),
    MenuItem(
      title: "財務管理",
      icon: Icons.attach_money,
      children: [
        MenuItem(title: " 月結帳單管理", icon: Icons.receipt_outlined),
        MenuItem(title: " 成本核算", icon: Icons.calculate_outlined),
        MenuItem(title: " 其他進項管理", icon: Icons.attach_money_outlined),
      ],
    ),
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
      appBar: getCustomAppBarByIndex(
        "", // 傳入空字串，暫時忽略 index
        context,
        isExpanded: _isExpanded,
        currentPath: _currentPath,
        onToggleExpanded: () {
          setState(() {
            if (_isExpanded) {
              if (_lastSelectedSubItem != null) {
                _selectedIndex = _lastSelectedSubItem!["parent"]!;
                _currentPath = "";
              }
              _menuExpanded.updateAll((key, value) => false);
            } else {
              if (_lastSelectedSubItem != null) {
                int parentIndex = _lastSelectedSubItem!["parent"]!;
                int childIndex = _lastSelectedSubItem!["child"]!;
                String parentTitle = _menuItems[parentIndex].title;
                _menuExpanded[parentTitle] = true;
                int newIndex = parentIndex;
                for (int i = 0; i < parentIndex; i++) {
                  if (_menuExpanded[_menuItems[i].title]!) {
                    newIndex += _menuItems[i].children.length;
                  }
                }
                _selectedIndex = newIndex + 1 + childIndex;
                _currentPath = "$parentTitle > ${_menuItems[parentIndex].children[childIndex].title}";
              }
            }
            _isExpanded = !_isExpanded;
          });
        },
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 側邊欄固定高度並支援滾動
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: IntrinsicHeight(
                child: SideBar(
                  selectedIndex: _selectedIndex,
                  isExpanded: _isExpanded,
                  menuExpanded: _menuExpanded,
                  menuItems: _menuItems,
                  onDestinationSelected: (index) {
                    setState(() {
                      int currentIndex = 0;
                      bool found = false;

                      for (int i = 0; i < _menuItems.length; i++) {
                        var category = _menuItems[i];
                        if (currentIndex == index) {
                          _menuExpanded.updateAll((key, value) => key == category.title ? value : false);
                          _menuExpanded[category.title] = !_menuExpanded[category.title]!;
                          _selectedIndex = i;
                          _currentPath = "";
                          _lastSelectedSubItem = null;
                          found = true;
                          break;
                        }
                        currentIndex++;

                        if (_menuExpanded[category.title]! && category.children.isNotEmpty) {
                          for (int j = 0; j < category.children.length; j++) {
                            if (currentIndex == index) {
                              _selectedIndex = currentIndex;
                              _currentPath = "${category.title} > ${category.children[j].title}";
                              _lastSelectedSubItem = {"parent": i, "child": j};
                              found = true;
                              break;
                            }
                            currentIndex++;
                          }
                        }
                        if (found) break;
                      }

                      if (!found) {
                        _selectedIndex = 0;
                        _currentPath = "";
                        _lastSelectedSubItem = null;
                        _menuExpanded.updateAll((key, value) => false);
                      }
                    });
                  },
                  onToggleExpanded: () {},
                  onToggleMenuExpanded: (title) {
                    setState(() {
                      _menuExpanded[title] = !_menuExpanded[title]!;
                      if (!_menuExpanded[title]! && _lastSelectedSubItem != null) {
                        int parentIndex = _menuItems.indexWhere((item) => item.title == title);
                        if (_lastSelectedSubItem!["parent"] == parentIndex) {
                          _selectedIndex = parentIndex;
                          _currentPath = "";
                          _lastSelectedSubItem = null;
                        }
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          // 內容區域支援滾動
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentPath.isNotEmpty ? _currentPath : "管理系統",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentPath.isNotEmpty
                          ? "這裡是${_currentPath.split(" > ").last}的內容"
                          : "歡迎使用管理系統",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}