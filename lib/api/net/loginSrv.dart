import '../../model/app_response.dart';

import '../diobase.dart';

class LoginSrv {
  //用户名密码和账户登录
  static Future<AppResponse> accountLogin(Map<String, String> map) {
    return ApiManager.instance.netFetch(
        {"url": '/new/home/login/mLogin', "method": "post", "form": false},
        params: map);
  }

  ///退出登录
  static Future<AppResponse> mLogout() {
    return ApiManager.instance.netFetch(
      {"url": '/api/v1/login/mLogout', "method": "post"},
    );
  }
}
