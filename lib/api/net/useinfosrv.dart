


import '../diobase.dart';
import '../../model/app_response.dart';

class UserInfoSrv {




  ///是否登录
  static Future<AppResponse> checkLogin() async {
    return ApiManager.instance.netFetch({"url": '/api/v1/login/isLogin'},params: null);
  }

  ///获取用户信息
  static Future<AppResponse> getUserInfo() async{
    return ApiManager.instance.netFetch({"url": '/api/v1/users/info'},params: null);
  }


  ///getTrainInfo
  static Future<AppResponse> getTrainInfo() async{
    return ApiManager.instance.netFetch({"url": '/edu/live/getTranInfo'},params: null);
  }

  ///获取用户分发资源
  static Future<AppResponse> getUserDistribute(int examType) async{
    return ApiManager.instance.netFetch({"url": '/api/v1/distribute/resource'},params: {"examType":examType.toString()});
  }


}
