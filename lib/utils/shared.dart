import 'package:flutter/cupertino.dart';

class ShareData {
  String userName;
  ShareData({this.userName = 'default'});
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShareData && userName == other.userName;
  }
}

// ignore: must_be_immutable
class SharedWidget extends InheritedWidget {
  ShareData shareData;

  SharedWidget({Key? key, required Widget child, required this.shareData})
      : super(key: key, child: child);

  static ShareData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SharedWidget>()!
        .shareData;
  }

  @override
  bool updateShouldNotify(SharedWidget oldWidget) {
    return shareData != oldWidget.shareData;
  }
}
