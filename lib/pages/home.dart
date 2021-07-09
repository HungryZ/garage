import 'package:flutter/material.dart';
import 'package:garage/pages/repair_bill_create.dart';
import 'package:garage/pages/repair_item_list.dart';
import 'package:garage/ui_tool/section_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _repairItems = [
    {
      'title': '新建维修单',
      'icon': 'new',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: 'CreateRepairBillPage'),
            builder: (context) {
              return CreateRepairBillPage();
            }));
      },
    },
    {
      'title': '查询维修单',
      'icon': 'search',
      'action': () {
        print('222');
      },
    },
    {
      'title': '新建维修项目',
      'icon': 'new',
      'action': (BuildContext context) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/createRepairItem', (route) => true);
      },
    },
    {
      'title': '维修项目列表',
      'icon': 'list',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RepairListPage(isSelectingItemForBill: false);
        }));
      },
    },
  ];
  final List<Map<String, dynamic>> _purchaseItems = [
    {
      'title': '新建采购单',
      'icon': 'new',
      'action': () {
        print('111');
      },
    },
    {
      'title': '查询采购单',
      'icon': 'search',
      'action': () {
        print('111');
      },
    },
    {
      'title': '管理采购项目',
      'icon': 'repair',
      'action': () {
        print('111');
      },
    },
  ];
  final List<Map<String, dynamic>> _otherItems = [
    {
      'title': '统计',
      'icon': 'statistics',
      'action': () {
        print('111');
      },
    },
    {
      'title': '扫一扫',
      'icon': 'scan',
      'action': () {
        print('111');
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SectionWidget.generateSectionView('维修', _repairItems),
          SectionWidget.generateSectionView('采购', _purchaseItems),
          SectionWidget.generateSectionView('其他', _otherItems),
        ],
      ),
    );
  }
}
