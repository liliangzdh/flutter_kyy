import 'package:flutter/material.dart';
import 'package:flutter_kaoyaya_plugin/flutter_kaoyaya_plugin.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutterkaoyaya/api/net/liveMicroSrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/provide/single_global_instance/appstate_bloc.dart';
import 'package:flutterkaoyaya/store/share_preferences.dart';
import 'package:flutterkaoyaya/views/WebView.dart';
import 'package:flutterkaoyaya/views/live/live_tip.dart';
import 'package:flutterkaoyaya/views/login/Login.dart';

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

  goWebView(BuildContext context, String resourceURL, {title}) async {
    String token = await SharePreferenceUtils.getToken();
    String jsCode = "";
    List<Map<String, String>> cookies = [];
    if (token != null && token.length > 0) {
      cookies.add({"k": "token", "v": token});
      cookies.add({"k": "app_version", "v": "1.8.7"});
//     flutterWebViewPlugin.launch(resourceURL,cookieList: cookies);
    }

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebView(
        url: resourceURL,
        token: token,
        cookie: cookies,
        title: title,
      );
    }));
  }

  cleanCookies() async {
    await flutterWebViewPlugin.cleanCookies();
    print("-----------> cookie clear ");
  }

  getCookie() async {
    print("-----------> get cookie  122");
    Map<String, String> cookie = await flutterWebViewPlugin.getCookies();
    print("------------->" + cookie.toString());
  }

  go(BuildContext context, dynamic any) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return any;
    }));
  }

  goLogin(BuildContext context) {
    go(context, Login());
  }

//  access: 0 | 1;
//  startTime: string;
//  liveID: number;
//  playbackId?:number;
//  free?: 0 | 1 | '0' | '1';
//  type?: 'live' | 'playback',
  //去直播界面
  goLive2(BuildContext context, int accessCode, String startTime, int free,
      int mediaId, String type) {
    bool isLogin = appStateBloc.value.isLogin;
    bool access = (free + accessCode) > 0;
    bool isStart = Utils.isLiveStarted(startTime);
    print("------------isStart:"+isStart.toString());
    print("------------access:"+access.toString());
    print("------------free:"+free.toString());
    print("------------accessCode:"+accessCode.toString());
    if (access && isStart) {
      if (isLogin) {
        LiveMicroSrv.getAccessToken(mediaId.toString())
            .then((AppResponse data) {
          if (data.code == 200) {
            var result = data.result;
            FlutterKaoyayaPlugin.live({
              "accessToken": result["accessToken"],
              "title": result["title"],
              "playbackId": mediaId.toString(),
              "type": type //live
            });
          } else {
            ToastUtils.show(data.msg);
          }
        });
      } else {
        goLogin(context);
      }
    } else {
      go(context, LiveTip(mediaId));
    }
  }

  //直播去直播
  goNowLive(String accessToken,String title ){
    FlutterKaoyayaPlugin.live({
      "accessToken": accessToken,
      "title": title,
      "type": "live" //live
    });
  }
}
