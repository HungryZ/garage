import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/pages/list_view/repair_item_search_page.dart';
import 'package:garage/pages/repair_item_CUD.dart';
import 'package:garage/pages/repair_item_model.dart';
import 'package:garage/ui_tool/refresh_footer.dart';

class RepairItemListPage extends StatefulWidget {
  final bool isSelectingItemForBill;

  RepairItemListPage(this.isSelectingItemForBill);
  @override
  State<StatefulWidget> createState() => RepairItemListPageState();
}

class RepairItemListPageState extends State<RepairItemListPage> {
  final appBarTitle = '维修项目列表';
  final needsRequestDataWhenInit = true;
  late final RepairItemSearchPage? searchPage;
  var loadingStatus = RefreshFooterStatus.refreshing;
  final List<RepairItemModel> items = [];
  final int size = 20;

  int _page = 1;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    searchPage = RepairItemSearchPage(widget.isSelectingItemForBill);

    if (needsRequestDataWhenInit) {
      requestFirstPageData();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _requestRepairList(_page + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: requestFirstPageData,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: items.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index != items.length) {
                return GestureDetector(
                  child: Container(
                    color: Colors.white, // 不加底色点击空白地方不触发点击事件
                    height: 50.w,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: itemView(items[index]),
                  ),
                  onTap: () {
                    itemClicked(index);
                  },
                );
              } else {
                return RefreshFooter(status: loadingStatus);
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              if (index == items.length - 1) return SizedBox();
              return Container(
                color: Colors.black12,
                height: 1,
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              );
            },
          ),
        ),
      ),
    );
  }

  _searchButton() {
    return IconButton(
      icon: Image.asset(
        'assets/search.png',
        width: 20,
        height: 20,
        color: Colors.white,
      ),
      onPressed: searchButtonClicked,
    );
  }

  PreferredSizeWidget? appBar() {
    return AppBar(
      title: Text(appBarTitle),
      actions: [_searchButton()],
    );
  }

  Widget? itemView(item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item.name),
        Text(item.price.toString()),
      ],
    );
  }

  /// Request

  Future<void> requestFirstPageData() async {
    await _requestRepairList(1);
  }

  Future<void> _requestRepairList(int page) async {
    if (loadingStatus == RefreshFooterStatus.idle && page != 1) return;

    final newItems = await requestItems(page);
    if (newItems == null) return;

    setState(() {
      _page = page;
      if (_page == 1) {
        items.clear();
      }
      items.addAll(newItems);
      if (newItems.length == size) {
        loadingStatus = RefreshFooterStatus.refreshing;
      } else {
        loadingStatus = RefreshFooterStatus.idle;
      }
    });
  }

  Future<List<RepairItemModel>?> requestItems(int page) async {
    final response = await requestOfPage(page);
    if (response == null) return null;

    final List newItemsJson = response['records'];
    if (newItemsJson.length == 0) return null;

    final List<RepairItemModel> newItems = [];
    newItemsJson.forEach((element) {
      final item = RepairItemModel();
      item.id = element['id'];
      item.name = element['name'];
      item.price = (element['price'] as double).toInt();
      newItems.add(item);
    });
    return newItems;
  }

  Future<Map<String, dynamic>?> requestOfPage(int page) {
    return Networking.request(
      '/api/repairProject/findByPage',
      method: HTTPMethod.GET,
      queryParameters: {'page': page, 'size': size},
    );
  }

  /// User Interaction

  void searchButtonClicked() {
    if (searchPage == null) return;

    Future result =
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return searchPage!;
    }));

    result.then((value) {
      handleBackFromSearchPage(value);
    });
  }

  void handleBackFromSearchPage(value) {
    if (value != null && widget.isSelectingItemForBill) {
      // 从创建维修单过来的, 并且在搜索页面选中了某一项
      Navigator.of(context).pop(value);
    } else {
      // 此时可能在搜索页面进入了详情页面进行了编辑，所以需要进行刷新
      // 但是不知道是修改了哪一个，所以只能重新载入数据
      requestFirstPageData();
    }
  }

  void itemClicked(int index) {
    if (widget.isSelectingItemForBill) {
      Navigator.of(context).pop(items[index]);
    } else {
      Future result =
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return RepairItemCUDPage(model: items[index]);
      }));
      result.then((value) {
        if (value == 1) {
          // 更新
          setState(() {});
        } else if (value == 2) {
          // 删除
          setState(() {
            items.removeAt(index);
          });
        }
      });
    }
  }
}
