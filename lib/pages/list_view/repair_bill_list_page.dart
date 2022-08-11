import 'package:flutter/material.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/pages/list_view/repair_item_list_page.dart';
import 'package:garage/pages/repair_bill_model.dart';

class RepairBillListPage extends RepairItemListPage {
  RepairBillListPage() : super(false);

  @override
  State<StatefulWidget> createState() => _RepairBillListPageState();
}

class _RepairBillListPageState extends RepairItemListPageState {

  @override
  String get appBarTitle => '维修单列表';

  @override
  void initState() {
    super.initState();

    searchPage = null;
  }

  @override
  Widget? itemView(item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item.carNo),
        Text(item.mileage.toString()),
      ],
    );
  }

  @override
  Future<Map<String, dynamic>?> requestOfPage(int page) {
    return Networking.request(
      '/api/repairForm/findByPage',
      method: HTTPMethod.GET,
      queryParameters: {'page': page, 'size': size},
    );
  }

  @override
  List decodeList(List itemsJson) {
    final List<RepairBillModel> newItems = [];
    itemsJson.forEach((element) {
      final item = RepairBillModel();
      item.id = element['id'];
      item.carNo = element['carNo'];
      item.carType = element['carType'];
      item.owner = element['owner'];
      item.phone = element['phone'];
      item.mileage = (element['mileage'] as double).toInt();
      item.projectDTOS = element['projectDTOS'] ?? [];
      newItems.add(item);
    });
    return newItems;
  }

  @override
  void handleBackFromSearchPage(value) {
    // TODO: implement handleBackFromSearchPage
    super.handleBackFromSearchPage(value);
  }

  @override
  Widget itemDetailPage(model) {
    // TODO: implement itemDetailPage
    return super.itemDetailPage(model);
  }
}
