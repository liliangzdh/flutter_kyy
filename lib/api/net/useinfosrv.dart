


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

  ///根据产品分类id获取用户课程
  static Future<AppResponse> getUserCourses(int sortTypeId) async{
    return ApiManager.instance.netFetch({"url": '/knew/home/user/mycourse?topId=${sortTypeId.toString()}'});
  }

  ///获取用户的学习资源 studyResource
  static Future<AppResponse> getStudyResource() async{
    return ApiManager.instance.netFetch({"url": '/api/v1/users/studyResource'});
  }

  ///获取分发的题库
  static Future<AppResponse> getDistributeSubject(String id) async{
    return ApiManager.instance.netFetch({"url": '/api/v1/distribute/subject'},params:{ "examType": id,});
  }


}
