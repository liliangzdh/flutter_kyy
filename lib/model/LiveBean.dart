import 'package:flutterkaoyaya/common/utils.dart';

class PreLiveBean {
  int mediaId;
  String picture;
  int expiryDay;
  int courseId;
  String nickname;
  String courseTitle;
  String lessonTitle="";

  String startTime;
  String endTime;
  String category;
  int free;
  int access;

  String type = "live";
  String title ;
  int  number ;

  PreLiveBean.fromJson(Map<String, dynamic> json) {
    mediaId = Utils.formatInt("mediaId", json);
    picture = json['picture'];
    expiryDay = Utils.formatInt("expiryDay", json);
    courseId = Utils.formatInt("courseId", json);
    nickname = json['nickname'];
    courseTitle = json['courseTitle'];
    lessonTitle = json['lessonTitle'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    category = json['category'];
    free = Utils.formatInt("free", json);
    access = Utils.formatInt("access", json);
    number = Utils.formatInt("number", json);
    title = json['title'];
  }


}
