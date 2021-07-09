import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/pages/repair_item_list.dart';
import 'package:garage/pages/repair_item_model.dart';
import 'package:garage/tool/input_validator/input_model.dart';
import 'package:garage/tool/input_validator/input_validator.dart';
import 'package:garage/tool/tools.dart';

class CreateRepairBillPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateRepairBillPageState();
}

class _CreateRepairBillPageState extends State<CreateRepairBillPage> {
  final List<InputModel> _columns = [
    InputModel(
      name: '车牌',
      placeholder: '请输入车牌',
      controller: TextEditingController(),
      validators: [InputValidator(InputValidateType.nonnull, '请输入车牌')],
    ),
    InputModel(
      name: '车型',
      placeholder: '请输入车型',
      controller: TextEditingController(),
      validators: [InputValidator(InputValidateType.nonnull, '请输入车型')],
    ),
    InputModel(
      name: '车主',
      placeholder: '请输入车主',
      controller: TextEditingController(),
    ),
    InputModel(
      name: '手机',
      placeholder: '请输入手机号码',
      controller: TextEditingController(),
      keyboardType: TextInputType.number,
    ),
    InputModel(
      name: '里程',
      placeholder: '请输入里程',
      controller: TextEditingController(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
  ];
  List<RepairItemModel> _repairItems = [];
  int _sum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: _buildUI(),
        ),
      ),
    );
  }

  List<Widget> _buildUI() {
    List<Widget> widgets = [];
    widgets.add(
      Container(
        padding: EdgeInsets.fromLTRB(15, 40, 0, 10),
        child: Text(
          '新建修理单',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
    widgets.add(
      Container(
        padding: EdgeInsets.fromLTRB(30, 20, 0, 10),
        child: Text(
          '基本信息',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );

    _columns.forEach((element) {
      widgets.add(
        Container(
          margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
          child: _themeTextField(
            element.name!,
            element.placeholder!,
            element.controller,
            keyboardType: element.keyboardType,
          ),
        ),
      );
    });

    widgets.add(
      Container(
        padding: EdgeInsets.fromLTRB(30, 40, 0, 10),
        child: Text(
          '维修项目',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );

    for (int i = 0; i < _repairItems.length; i++) {
      widgets.add(
        Container(
          height: 50.w,
          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_repairItems[i].name),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        if (_repairItems[i].count == 1) {
                          _repairItems.removeAt(i);
                        } else {
                          _repairItems[i].count -= 1;
                        }
                        _calculateSum();
                      });
                    },
                    icon: Image.asset(
                      'assets/subtract.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
                  Text('${_repairItems[i].count}'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _repairItems[i].count += 1;
                        _calculateSum();
                      });
                    },
                    icon: Image.asset(
                      'assets/plus.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 52.w,
                    child: Text(
                        '¥${_repairItems[i].price * _repairItems[i].count}'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    widgets.add(
      Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Text('添加维修项目>',
                  style: TextStyle(fontSize: 12, color: Colors.blue)),
              onTap: () {
                Future result = Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return RepairListPage(isSelectingItemForBill: true);
                }));
                result.then((value) {
                  // print(value);
                  if (value != null) {
                    setState(() {
                      RepairItemModel? existModel;
                      for (final model in _repairItems) {
                        if (model.id == value.id) {
                          existModel = model;
                          break;
                        }
                      }
                      if (existModel != null) {
                        existModel.count += 1;
                      } else {
                        _repairItems.add(value);
                      }
                      _calculateSum();
                    });
                  }
                });
              },
            ),
            Text('合计 ¥ $_sum'),
          ],
        ),
      ),
    );

    widgets.add(
      Container(
        margin: EdgeInsets.fromLTRB(80.w, 60, 80.w, 40),
        height: 48.w,
        child: ElevatedButton(
          onPressed: _createButtonClicked,
          child: Text('创  建', style: TextStyle(fontSize: 18)),
        ),
      ),
    );

    return widgets;
  }

  TextField _themeTextField(
    String leftText,
    String placeHolder,
    TextEditingController? controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Container(
          alignment: Alignment.center,
          width: 32,
          child: Text(leftText),
        ),
        hintText: placeHolder,
        hintStyle: TextStyle(color: Color(0xFFB2B2B2), fontSize: 14),
      ),
    );
  }

  void _createButtonClicked() {
    if (InputValidator.check(_columns)) {
      Networking.request('/api/repairForm/saveOrUpdate',
          method: HTTPMethod.POST,
          queryParameters: {
            'carNo': _columns[0].controller!.text,
            'carType': _columns[1].controller!.text,
            'owner': _columns[2].controller!.text,
            'phone': _columns[3].controller!.text,
            'mileage': double.parse(_columns[4].controller!.text),
            'projectDTOS': [
              {'id': '1'}
            ],
          }, succeedCallback: (responseData) async {
        toast('创建成功');
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pop();
        });
      });
    }
  }

  _calculateSum() {
    _sum = 0;
    _repairItems.forEach((element) {
      _sum += element.price * element.count;
    });
  }
}
