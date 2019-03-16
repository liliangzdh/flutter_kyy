class LiveInfo {
  String courseName = "";
  int courseId = 0;
  String nickname = "";
  String title = "";
  String picture = "";
  String startTime = "";
  String endTime = "";

  LiveInfo();

  LiveInfo.fromJson(Map<String, dynamic> json) {
    courseName = json['course_name'];
    courseId = json['courseId'];
    nickname = json['nickname'];
    title = json['title'];
    picture = json['picture'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }
}
