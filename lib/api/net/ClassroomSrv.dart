import 'package:flutterkaoyaya/model/app_response.dart';

import '../../api/diobase.dart';

class ClassroomMicroSrv {

  ///  获取班级学习资源
  static Future<AppResponse> learnInfo(int id) {
    return ApiManager.instance.netFetch({
      "url": '/api/v1/edu/class/${id.toString()}/learnInfo',
    });
  }
}
