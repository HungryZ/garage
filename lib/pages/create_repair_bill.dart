import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garage/networking/networking.dart';
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
  List repairItems = [];

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

    widgets.add(
      GestureDetector(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Text('添加维修项目>',
              style: TextStyle(fontSize: 12, color: Colors.blue)),
        ),
        onTap: () {
          print('tapped');
        },
      ),
    );

    widgets.add(
      Container(
        margin: EdgeInsets.fromLTRB(80.w, 60, 80.w, 0),
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
      // focusNode: accountFocusNode,
      // autofocus: true,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Container(
          alignment: Alignment.center,
          width: 32,
          child: Text(leftText),
        ),
        // focusedBorder:
        //     UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
        hintText: placeHolder,
        hintStyle: TextStyle(color: Color(0xFFB2B2B2), fontSize: 14),
      ),
    );
  }

  void _createButtonClicked() {
    if (InputValidator.check(_columns)) {
      Networking.request('/api/repairProject/saveOrUpdate',
          method: HTTPMethod.POST,
          queryParameters: {
            'name': _columns[0].controller!.text,
            'price': double.parse(_columns[1].controller!.text),
          }, succeedCallback: (responseData) async {
        toast('创建成功');
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pop();
        });
      });
    }
  }
}
