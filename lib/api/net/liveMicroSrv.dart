import '../diobase.dart';
import '../../model/app_response.dart';

class LiveMicroSrv {
  ///获取全网7天内前4个直播预告
  static Future<AppResponse> homeLivePreLive() {
    return ApiManager.instance.send({"url": '/knew/api/wap/preLive'});
  }

  ///获取直播 accessToken
  static Future<AppResponse> getAccessToken(String liveID) {
    return ApiManager.instance
        .send({"url": '/new/api/live/getAccessToken'}, params: {"id": liveID});
  }
}
