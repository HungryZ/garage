import 'package:flutter/material.dart';

enum RefreshFooterStatus {
  // normal,
  refreshing,
  idle,
}

class RefreshFooter extends StatelessWidget {
  final RefreshFooterStatus status;

  const RefreshFooter({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: status == RefreshFooterStatus.refreshing,
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(
                status == RefreshFooterStatus.refreshing ? '加载中' : '没有更多了',
                style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
