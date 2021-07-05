import 'package:flutter/material.dart';
import 'package:garage/ui_tool/section_widget.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final List<Map<String, dynamic>> _mineItems = [
    {
      'title': '修改密码',
      'icon': 'xiugaimima',
      'action': () {
        print('111');
      },
    },
    {
      'title': '退出登陆',
      'icon': 'log-out',
      'action': () {
        print('222');
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SectionWidget.generateSectionView('我的', _mineItems),
        ],
      ),
    );
  }
}
