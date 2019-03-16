import 'dart:async';

import 'package:flutter/services.dart';

class FlutterKaoyayaPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_kaoyaya_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void live (Map<String,String> data){
      _channel.invokeMethod('live',data);
  }

  static void downloadList (){
      _channel.invokeMethod('downloadList');
  }
}
