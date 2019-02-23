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

  static int formatInt(String key, Map<String, dynamic> json) {
    if (json[key] == null) {
      return 0;
    }
    var value = json[key];

    if (value is String) {
      try {
        return int.parse(value);
      } catch (E) {
        print("----------->" + key + "不是个string类型的int");
        return 0;
      }
    } else if (value is int) {
      return value;
    }
    return 0;
  }
}
