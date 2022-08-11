import 'package:flutter/material.dart';
import 'package:garage/pages/list_view/repair_item_list_page.dart';
import 'package:garage/pages/purchase_item_CUD.dart';
import 'package:garage/pages/purchase_item_list.dart';
import 'package:garage/pages/purchase_order_create.dart';
import 'package:garage/pages/purchase_order_list.dart';
import 'package:garage/pages/repair_bill_create.dart';
import 'package:garage/pages/list_view//repair_bill_list_page.dart';
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
              return RepairBillCreatePage();
            }));
      },
    },
    {
      'title': '维修单列表',
      'icon': 'list',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RepairBillListPage();
        }));
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
          return RepairItemListPage(false);
        }));
      },
    },
  ];
  final List<Map<String, dynamic>> _purchaseItems = [
    {
      'title': '新建采购单',
      'icon': 'new',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PurchaseOrderCreatePage();
        }));
      },
    },
    {
      'title': '采购单列表',
      'icon': 'list',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PurchaseOrderListPage();
        }));
      },
    },
    {
      'title': '新建采购项目',
      'icon': 'new',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PurchaseItemCUDPage();
        }));
      },
    },
    {
      'title': '采购项目列表',
      'icon': 'list',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PurchaseItemListPage();
        }));
      },
    },
  ];
  final List<Map<String, dynamic>> _otherItems = [
    {
      'title': '统计',
      'icon': 'statistics',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RepairBillCreatePage();
        }));
      },
    },
    {
      'title': '扫一扫',
      'icon': 'scan',
      'action': (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RepairBillCreatePage();
        }));
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
