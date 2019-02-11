import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutterkaoyaya/store/share_preferences.dart';
import 'package:flutterkaoyaya/views/WebView.dart';

class RouteUtils {
//

  factory RouteUtils() => _getInstance();

  static RouteUtils get instance => _getInstance();
  static RouteUtils _instance;
  static FlutterWebviewPlugin flutterWebViewPlugin;
  RouteUtils._internal() {
    // 初始化
    flutterWebViewPlugin = FlutterWebviewPlugin();
  }

  static RouteUtils _getInstance() {
    if (_instance == null) {
      _instance = new RouteUtils._internal();
    }
    return _instance;
  }

  goWebView(BuildContext context, String resourceURL,{title}) async {
    String token = await SharePreferenceUtils.getToken();
    String jsCode = "";
    List<Map<String,String>> cookies = [];
    if(token != null && token.length >0){
     cookies.add({"k":"token","v":token});
     cookies.add({"k":"app_version","v":"1.8.7"});
//     flutterWebViewPlugin.launch(resourceURL,cookieList: cookies);
    }

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebView(url: resourceURL,token:token,cookie:cookies,title: title,);
    }));
  }

  cleanCookies() async{
    await flutterWebViewPlugin.cleanCookies();
    print("-----------> cookie clear ");
  }

  getCookie() async{
    print("-----------> get cookie  122");
    Map<String,String> cookie = await flutterWebViewPlugin.getCookies();
    print("------------->"+cookie.toString());
  }


}
