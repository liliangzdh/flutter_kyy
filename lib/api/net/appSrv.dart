


import '../../api/diobase.dart';
import '../../model/app_response.dart';

class AppSrv{

  ///版本信息
  static Future<AppResponse> versionInfo() async {
    return ApiManager.instance.netFetch({"url": '/api/v1/app/getVersionInfo'},params: {"versionCode":'1.8.7'});
  }

  ///获取当前机构的考试类型
  static Future<AppResponse> getOemExamTypeList() async {
    return ApiManager.instance.netFetch({"url": '/api/v1/distribute/examType'},params: null);
  }
}