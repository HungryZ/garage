import 'package:garage/networking/networking.dart';
import 'package:garage/pages/list_view_model.dart';
import 'package:garage/pages/repair_item_model.dart';

class RepairItemListViewModel implements ListViewModel {
  final int _size = 20;

  @override
  Future<List<RepairItemModel>?> requestItems(int page) async {
    final response = await Networking.request('/api/repairProject/findByPage',
        method: HTTPMethod.GET, queryParameters: {'page': page, 'size': _size});
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
}
