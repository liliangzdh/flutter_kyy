import '../diobase.dart';
import '../../model/app_response.dart';

class LiveMicroSrv {

  ///获取全网7天内前4个直播预告
  static Future<AppResponse> homeLivePreLive() {
    return ApiManager.instance.send({"url": '/knew/api/wap/preLive'});
  }
}
