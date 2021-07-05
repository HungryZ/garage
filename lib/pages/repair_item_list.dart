import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/ui_tool/refresh_footer.dart';

class RepairListPage extends StatefulWidget {
  final int ssss = 0;
  @override
  State<StatefulWidget> createState() => _RepairListPageState();
}

class _RepairListPageState extends State<RepairListPage> {
  final int _size = 20;
  int _page = 1;
  List _items = [];
  final _controller = ScrollController();
  var _loadingStatus = RefreshFooterStatus.refreshing;

  @override
  void initState() {
    super.initState();

    _requestFirstPageData();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _requestRepairList(_page + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _requestFirstPageData,
          child: ListView.separated(
            controller: _controller,
            itemCount: _items.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index != _items.length) {
                return GestureDetector(
                  child: Container(
                    height: 50.w,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_items[index]['name']),
                        Text(_items[index]['price'].toString()),
                      ],
                    ),
                  ),
                  onTap: () {
                    _itemClicked(index);
                  },
                );
              } else {
                return RefreshFooter(_loadingStatus);
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
    if (_loadingStatus == RefreshFooterStatus.idle && page != 1) return;

    await Networking.request('/api/repairProject/findByPage',
        method: HTTPMethod.GET,
        queryParameters: {
          'page': page,
          'size': _size,
        }, succeedCallback: (responseData) async {
      final List newItems = responseData['records'];
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
    print(index);
  }
}
