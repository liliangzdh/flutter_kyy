/**
 * 获取直播详情
 * @param id
 */

import '../../api/diobase.dart';
import '../../model/app_response.dart';

class LiveSrv {
  ///获取直播详情
  static Future<AppResponse> getLiveInfo(String liveId) async {
    return ApiManager.instance
        .netFetch({"url": '/new/api/live/getLiveInfo'}, params: {"id": liveId});
  }
}
