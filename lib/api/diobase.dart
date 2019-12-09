import 'dart:io';

import 'package:dio/dio.dart';
import '../model/app_response.dart';
import '../store/share_preferences.dart';
import '../config/config.dart';
import '../provide/single_global_instance/appstate_bloc.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApiManager {
  // 工厂模式
  factory ApiManager() => _getInstance();

  static ApiManager get instance => _getInstance();
  static ApiManager _instance;

  static Dio dio;

  ApiManager._internal() {
    // 初始化
    dio = new Dio();
    // 配置dio实例
    dio.options.baseUrl = Api.BASE_URL;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    dio.options.headers.addAll({"Origin": Api.BASE_URL});
//    dio.options.headers.addAll({"User-Agent": "IOS/WEBVIEW"});
    //设置代理 配合 charles  抓包
//    dio.onHttpClientCreate = (HttpClient client) {
//      client.findProxy = (uri) {
//        return "PROXY 192.168.2.102:8888";
//      };
//    };
  }

  static ApiManager _getInstance() {
    if (_instance == null) {
      _instance = new ApiManager._internal();
    }
    return _instance;
  }

  Future<AppResponse> netFetch(Map<String, dynamic> map,
      {Map<String, String> params}) async {
    AppResponse appResponse = await send(map, params: params);

    //401代表未登录或过期
    if (appResponse.code == 401) {
      String token = await SharePreferenceUtils.getToken();
      if (token!= null && token.length >0){
        //清除token
        await SharePreferenceUtils.saveToken("");
        print("------------->401了 清除登录的token");
        appStateBloc.setUerInfo(null);
      }
    }

    return Future.value(appResponse);
  }

  ///发送请求
  Future<AppResponse> send(Map<String, dynamic> map,
      {Map<String, dynamic> params}) async {
    var url = map['url'];
    var method = map['method'];
    bool isFormData = map['form'];
    Response response;

    String token = await SharePreferenceUtils.getToken();
    if (token != null && token.length > 0) {
      print("-----token"+token);
      dio.options.headers.addAll({"x-token": token});
    }


    try {
      if (method == null) {
        //说明是get
        response = await dio.get(url, data: params);
      } else {
        //说明是post
        if (isFormData != null && isFormData == false) {
          response = await dio.post(url, data: new FormData.from(params));
        } else {
          response = await dio.post(url, data: params);
        }
      }

      AppResponse app;
      if (response.statusCode == HttpStatus.ok) {
        print("response:${response.data}");
        app = new AppResponse.fromJson(response.data);
      } else {
        app = new AppResponse(response.statusCode, "获取数据错误", null);
      }
      return Future.value(app);
    } on DioError catch (err) {
      print("---------dio error ");
      print(err.toString());

      AppResponse appResponse = new AppResponse(900, "连接不上网络:"+err.message, null);
      if (err.response != null) {
        var resData = err.response.data;
        print("------------->虽然异常了，但是还是有返回的:" + resData.toString());
      }
      if (err.type == DioErrorType.CONNECT_TIMEOUT) {
        appResponse = new AppResponse(
            HttpStatus.networkConnectTimeoutError, "连接超时", null);
      }

      return Future.value(appResponse);
    } catch (exception) {
      print("---------dio othter error");
      print(exception.toString());
      return Future.value(new AppResponse(1000, "其他错误", null));
    }
  }
}
