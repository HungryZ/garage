import 'package:flutter/material.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/pages/repair_bill_model.dart';
import 'package:garage/ui_tool/refresh_footer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RepairBillListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RepairBillListPagePageState();
}

class _RepairBillListPagePageState extends State<RepairBillListPage> {
  final int _size = 20;
  int _page = 1;
  List<RepairBillModel> _items = [];
  final _scrollController = ScrollController();
  var _loadingStatus = RefreshFooterStatus.refreshing;

  @override
  void initState() {
    super.initState();

    _requestFirstPageData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _requestRepairBillList(_page + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('维修项目列表'),
        actions: [_searchButton()],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _requestFirstPageData,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: _items.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index != _items.length) {
                return GestureDetector(
                  child: Container(
                    color: Colors.white, // 不加底色点击空白地方不触发点击事件
                    height: 50.w,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_items[index].carNo),
                        Text(_items[index].mileage.toString()),
                      ],
                    ),
                  ),
                  onTap: () {
                    _itemClicked(index);
                  },
                );
              } else {
                return RefreshFooter(status: _loadingStatus);
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              if (index == _items.length - 1) return SizedBox();
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
      onPressed: () {
        // Future result =
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return RepairItemSearchPage(
        //     isSelectingItemForBill: widget.isSelectingItemForBill,
        //   );
        // }));
        //
        // result.then((value) {
        //   if (value != null) {
        //     // 从创建维修单过来的，然后再搜索页面选中了某一项
        //     Navigator.of(context).pop(value);
        //   } else if (!widget.isSelectingItemForBill) {
        //     // 从列表过来的，然后再搜索页面点了返回，此时可能在搜索页面进入了详情页面进行了编辑，所以需要进行刷新
        //     // 但是不知道是修改了哪一个，所以只能重新载入数据
        //     _requestFirstPageData();
        //   }
        // });
      },
    );
  }

  Future<void> _requestFirstPageData() async {
    await _requestRepairBillList(1);
  }

  _requestRepairBillList(int page) async {
    if (_loadingStatus == RefreshFooterStatus.idle && page != 1) return;

    await Networking.request('/api/repairForm/findByPage',
        method: HTTPMethod.GET,
        queryParameters: {
          'page': page,
          'size': _size,
        }, succeedCallback: (responseData) async {
          final List newItemsJson = responseData['records'];
          final List<RepairBillModel> newItems = [];
          newItemsJson.forEach((element) {
            final item = RepairBillModel();
            item.id = element['id'];
            item.carNo = element['carNo'];
            item.carType = element['carType'];
            item.owner = element['owner'];
            item.phone = element['phone'];
            item.mileage = (element['mileage'] as double).toInt();
            item.projectDTOS = element['projectDTOS'];
            newItems.add(item);
          });
          setState(() {
            _page = page;
            if (_page == 1) {
              _items.clear();
            }
            _items.addAll(newItems);
            if (newItems.length == _size) {
              _loadingStatus = RefreshFooterStatus.refreshing;
            } else {
              _loadingStatus = RefreshFooterStatus.idle;
            }
          });
        });
  }

  _itemClicked(int index) {
    // if (widget.isSelectingItemForBill) {
    //   Navigator.of(context).pop(_items[index]);
    // } else {
    //   Future result =
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //     return RepairItemCUDPage(model: _items[index]);
    //   }));
    //   result.then((value) {
    //     if (value == 1) {
    //       // 更新
    //       setState(() {});
    //     } else if (value == 2) {
    //       // 删除
    //       setState(() {
    //         _items.removeAt(index);
    //       });
    //     }
    //   });
    // }
  }
}
