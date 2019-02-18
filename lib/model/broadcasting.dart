//录播课modal
class BroadCastingVideo {
  String picture;
  String title;
  String id;
  String type;
  String url;
  int isActivate;
  String activationTime;
  String deadline;
  int categoryId;
  int expiryDay;
  int hitNum;
  int studentNum;
  int memberStart;
  int lessonNum;
  String lastLearnLesson;
  String lastLearnTime;
  int mediaId;
  String lessonTitle;
  int topId;
  int progress;

  BroadCastingVideo.fromJson(Map<String, dynamic> json) {
    picture = json['picture'];
    title = json['title'];
    id = json['id'];
    type = json['type'];
    url = json['url'];
    isActivate = int.parse(json['is_activate']);
    activationTime = json['activation_time'];
    deadline = json['deadline'];
    categoryId = int.parse(json['categoryId']);
    expiryDay = int.parse(json['expiryDay']);
    hitNum = int.parse(json['hitNum']);
    studentNum = int.parse(json['studentNum']);
    memberStart = int.parse(json['memberStart']);
    lessonNum = int.parse(json['lessonNum']);
    lastLearnLesson = json['last_learn_lesson'];
    lastLearnTime = json['last_learn_time'];
    String _mediaId =  json['mediaId'];

    if(_mediaId == null){
      mediaId = 0;
    }else{
      mediaId = int.parse(_mediaId);
    }
    lessonTitle = json['lessonTitle'];
    topId = int.parse(json['topId']);
    progress = json['progress'];
  }
}
