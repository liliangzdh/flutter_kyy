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

  ///获取科目推荐 薄弱 知识点列表
  static Future<AppResponse> getRecommendKnows(int subjectID) {
    return ApiManager.instance.netFetch(
        {"url": '/api/v1/subjects/${subjectID.toString()}/knowledgeWeakness'},
        params: {"pageSize": 3.toString(), "page": 1.toString()});
  }

  /// 获取科目练习统计数据
  static Future<AppResponse> getSubjectStatistic(int subjectID) {
    return ApiManager.instance.netFetch(
        {"url": '/api/v1/subjects/$subjectID/statistic'});
  }

  ///检验科目权限
  static Future<AppResponse> checkSubjectAccess(int subjectID) {
    return ApiManager.instance
        .netFetch({"url": '/api/v1/subjects/${subjectID.toString()}/access'});
  }

  ///获取科目信息
  static Future<AppResponse> getSubjectInfo(int subjectID) {
    return ApiManager.instance
        .netFetch({"url": '/api/v1/subjects/$subjectID/info'});
  }
}
