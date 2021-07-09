import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garage/pages/repair_item_CUD.dart';
import 'package:garage/pages/login.dart';
import 'package:garage/pages/mine.dart';
import 'package:garage/ui_tool/tab_bar_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 667),
      builder: () => MaterialApp(
        title: 'Garage',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        navigatorKey: navigatorKey,
        routes: {
          '/loginPage': (context) => LoginPage(),
          '/minePage': (context) => MinePage(),
          '/tabBar': (context) => TabBarController(),
          '/createRepairItem': (context) => RepairItemCUDPage(),
        },
        // initialRoute: '/login',
        // onGenerateRoute: _getRoute,
        home: FutureBuilder(
          future: _configRootVC(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) return snapshot.data;
            return Container(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

_configRootVC() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  print(token);
  // if (token != null && token.length > 0) {
    return TabBarController();
  // } else {
  //   return LoginPage();
  // }
}

// Route<dynamic>? _getRoute(RouteSettings settings) {
//   if (settings.name != '/tabBar') {
//     return null;
//   }
//
//   return MaterialPageRoute<void>(
//     settings: settings,
//     builder: (BuildContext context) => LoginPage(),
//     fullscreenDialog: true,
//   );
// }
