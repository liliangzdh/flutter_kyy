import 'package:flutter/material.dart';

class Utils {
  ///获取状态栏高度
  static getStateBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
}
