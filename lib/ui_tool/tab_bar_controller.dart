import 'package:flutter/material.dart';
import 'package:garage/pages/home.dart';
import 'package:garage/pages/mine.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<TabBarController> {
  static const _defaultIndex = 0;
  var _selectedIndex = _defaultIndex;
  final _controller = new PageController(initialPage: _defaultIndex);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          MinePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // elevation: 0,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        selectedItemColor: Colors.black,
        unselectedFontSize: 12,
        unselectedItemColor: Colors.black54,
        items: [
          _bottomItem('home', 'home', "首页"),
          _bottomItem('mine', 'mine', "我的"),
        ],
        onTap: (i) {
          _controller.jumpToPage(i);
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
    );
  }

  _bottomItem(String normalImage, String activeImage, String title) {
    return BottomNavigationBarItem(
      icon: Image.asset('assets/$normalImage.png', width: 20, height: 20),
      activeIcon: Image.asset('assets/$activeImage.png', width: 20, height: 20),
      label: title,
    );
  }
}