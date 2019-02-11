import 'package:flutterkaoyaya/api/diobase.dart';
import 'package:flutterkaoyaya/model/app_response.dart';

class TiKuSrv {

  ///是否登录
  static Future<AppResponse> getDistributeSubject(int examType) async {
    return ApiManager.instance.netFetch({"url": '/api/v1/distribute/subject'},
        params: {"examType": examType.toString()});
  }

  ///获取考试类型下的科目
  /// @param { int } subjectID - 考试类型编号
  static Future<AppResponse> getSubjects(int subjectID) {
    return ApiManager.instance.netFetch(
        {"url": '/api/v1/subjects/${subjectID.toString()}/subjects'},
        params: null);
  }
}
