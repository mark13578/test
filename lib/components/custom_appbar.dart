import 'package:flutter/material.dart';

import '../utils/logger.dart';

/// 根據傳入的參數, 判定該呈現什麼樣子的 AppBar
PreferredSizeWidget getCustomAppBarByIndex(
  String index,
  BuildContext context, {
  required bool isExpanded,
  required String currentPath,
  required VoidCallback onToggleExpanded,
}) {
  logger.i("進入getCustomAppBarByIndex，index為$index");
  return PreferredSize(
    preferredSize: const Size.fromHeight(50), //Size.fromHeight(MediaQuery.sizeOf(context).height * 0.075),
    child: AppBar(
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 126, 137, 161),
      elevation: 0,
      leading: Transform.translate(
        offset: const Offset(14, 0), // 向左移動 20 像素
        child: IconButton(
          icon: Icon(
            isExpanded ? Icons.menu_open : Icons.menu,
            color: Colors.white,
          ),
          onPressed: onToggleExpanded,
        ),
      ),
      title: Text(
        currentPath.isNotEmpty ? currentPath : "管理系統",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
