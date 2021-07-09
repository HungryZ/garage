import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garage/pages/repair_item_model.dart';
import 'package:garage/tool/input_validator/input_model.dart';
import 'package:garage/tool/input_validator/input_validator.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/tool/tools.dart';

import '../main.dart';

class RepairItemCUDPage extends StatelessWidget {
  final RepairItemModel? model;
  final List<InputModel> _columns = [
    InputModel(
      name: '名称',
      placeholder: '请输入名称',
      controller: TextEditingController(),
      validators: [InputValidator(InputValidateType.nonnull, '请输入名称')],
    ),
    InputModel(
      name: '价格',
      placeholder: '请输入价格',
      controller: TextEditingController(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validators: [
        InputValidator(InputValidateType.nonnull, '请输入价格'),
        InputValidator(InputValidateType.number, '价格非法'),
      ],
    ),
  ];

  RepairItemCUDPage({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model != null) {
      _columns[0].controller!.text = model!.name;
      _columns[1].controller!.text = model!.price.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${model == null ? '新建' : '编辑'}维修项目'),
        actions: model == null
            ? null
            : [
                IconButton(
                  icon: Image.asset(
                    'assets/delete.png',
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),
                  onPressed: _deleteButtonClicked,
                ),
              ],
      ),
      body: SafeArea(
        child: ListView(
          children: _buildUI(),
        ),
      ),
    );
  }

  List<Widget> _buildUI() {
    List<Widget> widgets = [];

    _columns.forEach((element) {
      widgets.add(Container(
        margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: _themeTextField(
          element.name!,
          element.placeholder!,
          element.controller,
          keyboardType: element.keyboardType,
        ),
      ));
    });

    widgets.add(
      Container(
        margin: EdgeInsets.fromLTRB(80.w, 100, 80.w, 0),
        height: 48.w,
        child: ElevatedButton(
          onPressed: _saveButtonClicked,
          child: Text('保  存', style: TextStyle(fontSize: 18)),
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

  void _saveButtonClicked() {
    if (InputValidator.check(_columns)) {
      final name = _columns[0].controller!.text;
      final price = int.parse(_columns[1].controller!.text);
      Networking.request('/api/repairProject/saveOrUpdate',
          method: HTTPMethod.POST,
          queryParameters: {
            'id': model?.id ?? '',
            'name': name,
            'price': price,
          }, succeedCallback: (responseData) async {
        toast('保存成功');
        if (model != null) {
          model!.name = name;
          model!.price = price;
        }
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(navigatorKey.currentState!.overlay!.context).pop(1);
        });
      });
    }
  }

  void _deleteButtonClicked() {
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Text("确定要删除吗"),
          actions: [
            TextButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.pop(context);
                _deleteAction();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAction() {
    Networking.request('/api/repairProject/deleteById',
        queryParameters: {
          'id': model!.id,
        },
        method: HTTPMethod.GET, succeedCallback: (response) async {
      toast('删除成功');
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pop(2);
      });
    });
  }
}
