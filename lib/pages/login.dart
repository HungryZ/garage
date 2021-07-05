import 'package:flutter/material.dart';
import 'package:garage/networking/networking.dart';
import 'package:garage/tool/tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final accountFocusNode = new FocusNode();
  final psdFocusNode = new FocusNode();
  final accountController = TextEditingController();
  final psdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 44.0),
          children: [
            SizedBox(height: 60),
            Image.asset(
              'assets/diamond.png',
              width: 80,
              height: 80,
            ),
            SizedBox(height: 60),
            TextField(
              controller: accountController,
              focusNode: accountFocusNode,
              // autofocus: true,
              decoration: InputDecoration(
                prefixIcon: Image.asset(
                  'assets/slanted_menu.png',
                  width: 28,
                  height: 28,
                ),
                border: InputBorder.none,
                hintText: "请输入账号",
                hintStyle: TextStyle(color: Color(0xFFB2B2B2), fontSize: 14),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: psdController,
              focusNode: psdFocusNode,
              decoration: InputDecoration(
                prefixIcon: Image.asset(
                  'assets/slanted_menu.png',
                  width: 28,
                  height: 28,
                ),
                border: InputBorder.none,
                hintText: "请输入密码",
                hintStyle: TextStyle(color: Color(0xFFB2B2B2), fontSize: 14),
              ),
            ),
            SizedBox(height: 60),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: MaterialButton(
                height: 50,
                onPressed: _loginButtonClicked,
                child: Text(
                  '登录',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                color: Color.fromRGBO(102, 94, 247, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginButtonClicked() async {
    if (psdController.text.length == 0) {
      toast('请输入密码');
      FocusScope.of(context).requestFocus(psdFocusNode);
      return;
    }
    // if (psdController.text.length != 6) {
    //   toast('短信验证码格式错误');
    //   FocusScope.of(context).requestFocus(psdFocusNode);
    //   return;
    // }
    Networking.request('/app/account/smsLogin', queryParameters: {
      'mobile': 'rsaEncrypt(accountController.text)',
      'code': psdController.text,
      'deviceType': '2',
      'pushToken': '',
    }, succeedCallback: (responseData) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['data']['token']);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/tabBar', (route) => false);
    });
  }
}
