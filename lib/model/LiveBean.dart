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

  PreLiveBean.fromJson(Map<String, dynamic> json) {
    mediaId = int.parse(json['mediaId']);
    picture = json['picture'];
    expiryDay = int.parse(json['expiryDay']);
    courseId = int.parse(json['courseId']);
    nickname = json['nickname'];
    courseTitle = json['courseTitle'];
    lessonTitle = json['lessonTitle'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    category = json['category'];
    free = int.parse(json['free']);
    access = json['access'];
  }
}
