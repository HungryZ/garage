import 'package:flutter/material.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/pages/list_view/repair_item_list_page.dart';
import 'package:garage/ui_tool/refresh_footer.dart';

class RepairItemSearchPage extends RepairItemListPage {
  RepairItemSearchPage(bool isSelectingItemForBill)
      : super(isSelectingItemForBill);

  @override
  State<StatefulWidget> createState() => RepairItemSearchPageState();
}

class RepairItemSearchPageState extends RepairItemListPageState {
  @override
  bool get needsRequestDataWhenInit => false;
  @override
  RefreshFooterStatus get loadingStatus => RefreshFooterStatus.idle;

  final _inputController = TextEditingController();

  @override
  PreferredSizeWidget? appBar() {
    return AppBar(
      title: TextField(
        controller: _inputController,
        autofocus: true,
        cursorColor: Colors.white70, // 光标颜色
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入搜索内容',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        onSubmitted: (text) {
          requestFirstPageData();
        },
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/search.png',
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          onPressed: requestFirstPageData,
        )
      ],
    );
  }

  @override
  Future<Map<String, dynamic>?> requestOfPage(int page) {
    return Networking.request(
      '/api/repairProject/pageByProperties',
      method: HTTPMethod.POST,
      queryParameters: {
        'page': page,
        'size': size,
        'name': _inputController.text,
      },
    );
  }

  @override
  void itemClicked(int index) {
    if (widget.isSelectingItemForBill) {
      Navigator.of(context).pop(items[index]);
    } else {
      super.itemClicked(index);
    }
  }
}
