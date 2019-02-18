import 'package:flutter/material.dart';

class Utils {
  ///获取状态栏高度
  static getStateBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static Size getScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return size;
  }

  static double getScreenWidth(BuildContext context) {
    return getScreen(context).width;
  }

  static double getScreenHeight(BuildContext context) {
    return getScreen(context).height;
  }
}
