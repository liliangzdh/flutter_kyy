import '../diobase.dart';
import '../../model/app_response.dart';

class LiveMicroSrv {
  ///获取全网7天内前4个直播预告
  static Future<AppResponse> homeLivePreLive() {
    return ApiManager.instance.send({"url": '/api/v1/live/newHotPreLive?isAll=1'});
  }

  ///获取直播 accessToken
  static Future<AppResponse> getAccessToken(String liveID) {
    return ApiManager.instance
        .send({"url": '/new/api/live/getAccessToken'}, params: {"id": liveID});
  }

  ///获取我的直播回放的班级id和课程id
  static Future<AppResponse> getLiveIdAndClassIdByReplayLive() {
    return ApiManager.instance
        .send({"url": '/api/v1/users/getLiveIdAndClassIdByReplayLive'});
  }

  ///获取我的直播预告
  static Future<AppResponse> getMyPreLive() {
    return ApiManager.instance.send(
      {"url": '/api/v1/users/preLive?isAllLive=1'},
    );
  }

  ///获取我的直播回放
  static Future<AppResponse> getMyPlaybackLive(
      int page, int pageSize, int sortCourse, int sortClassroom) {
    return ApiManager.instance.send({
      "url": '/api/v1/users/replayLive',
      "method":"post",
    }, params: {
      "page": page,
      "pageSize": pageSize,
      "sortCourse": sortCourse,
      "sortClassroom": sortClassroom,
      "isAllLive":1,
    });
  }
}
