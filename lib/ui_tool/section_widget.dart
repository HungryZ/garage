import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';

class SectionWidget {
  static final _itemWidth = 88.w;
  static final _itemHeight = 70.0;
  static final _lineSpacing = 10.0;

  static Widget generateSectionView(String title, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 40, 0, 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: _calculateSectionHeight(items),
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: _lineSpacing,
            children: items.map((e) => _getItemContainer(e)).toList(),
          ),
        ),
      ],
    );
  }

  static Widget _getItemContainer(Map<String, dynamic> item) {
    final title = item['title']!;
    final action = item['action'];
    return Container(
      width: _itemWidth,
      height: _itemHeight,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Image.asset('assets/${item['icon']}.png', width: 28, height: 28),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 13)),
          ],
        ),
        onPressed: () {
          action(navigatorKey.currentState!.overlay!.context);
        },
      ),
    );
  }

  static double _calculateSectionHeight(List items) {
    if (items.length == 0) {
      return 0;
    }
    var rows = ((items.length - 1) / 4).floor() + 1;
    double height = rows * _itemHeight;
    if (rows > 1) {
      height += (rows - 1) * _lineSpacing;
    }
    return height;
  }
}
