import 'package:flutter/material.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/pages/repair_item_CUD.dart';
import 'package:garage/pages/repair_item_model.dart';
import 'package:garage/tool/tools.dart';
import 'package:garage/ui_tool/refresh_footer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RepairItemSearchPage extends StatefulWidget {
  final bool isSelectingItemForBill;

  const RepairItemSearchPage({Key? key, required this.isSelectingItemForBill})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RepairItemSearchPageState();
}

class _RepairItemSearchPageState extends State<RepairItemSearchPage> {
  final int _size = 20;
  int _page = 1;
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  List<RepairItemModel> _items = [];
  var _loadingStatus = RefreshFooterStatus.idle;

  @override
  void initState() {
    super.initState();

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
      appBar: AppBar(
        title: TextField(
          controller: _inputController,
          autofocus: true,
          cursorColor: Colors.white70,  // 光标颜色
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '请输入搜索内容',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          onSubmitted: (text) {
            _requestFirstPageData();
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
            onPressed: _requestFirstPageData,
          )
        ],
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
                        Text(_items[index].name),
                        Text(_items[index].price.toString()),
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

  Future<void> _requestFirstPageData() async {
    await _requestRepairList(1);
  }

  _requestRepairList(int page) async {
    if (_inputController.text.length == 0) {
      toast('搜索内容不能为空');
      return;
    }
    Networking.request('/api/repairProject/pageByProperties',
        method: HTTPMethod.POST,
        queryParameters: {
          'page': page,
          'size': _size,
          'name': _inputController.text,
        }, succeedCallback: (responseData) async {
      final List newItemsJson = responseData['records'];
      final List<RepairItemModel> newItems = [];
      newItemsJson.forEach((element) {
        final item = RepairItemModel();
        item.name = element['name'];
        item.price = (element['price'] as double).toInt();
        item.id = element['id'];
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
    if (widget.isSelectingItemForBill) {
      Navigator.of(context).pop(_items[index]);
    } else {
      Future result =
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return RepairItemCUDPage(model: _items[index]);
      }));
      result.then((value) {
        if (value == 1) {
          // 更新
          setState(() {});
        } else if (value == 2) {
          // 删除
          setState(() {
            _items.removeAt(index);
          });
        }
      });
    }
  }
}
