import '../common/utils.dart';

class LessonInfoItem {
  int free;
  int id;
  int learnStatus;
  int length;
  String lessonType;
  int number;
  String status;
  String target;
  String title;
  String type;
  String url;

  int chapterIndex = 0;
  bool open = false;
  bool isSelect = false;//是否选中的。

  @override
  String toString() {
    return 'LessonInfoItem{ title: $title, type: $type, chapterIndex: $chapterIndex, open: $open}';
  }

  LessonInfoItem.fromJson(Map<String, dynamic> json) {
    free = json['free'] == null ? 0 : int.parse(json['free']);
    id = int.parse(json['id']);
    learnStatus = json['learnStatus'];
    length = json['length'] == null ? 0 : int.parse(json['length']);
    lessonType = json['lessonType'];
    number = int.parse(json['number']);
    status = json['status'];
    target = json['target'];
    title = json['title'];
    type = json['type'];
    url = json['url'];
  }
}

class LessonInfo {
  String content;
  int courseId;
  int current_time;
  String file_num;
  int free; //'0' | '1';:
  String learnTime;
  int id;
  int lessonId;
  int mediaId;
  int number;
  String outUrl;
  String status;
  String target;
  String title="";
  String type;
  String url;
  String video_id;

  VideoInfos videoInfo;

  LessonInfo.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    courseId = Utils.formatInt("courseId", json);
    current_time = Utils.formatInt("current_time", json);
    free = Utils.formatInt("free", json);
    learnTime = json['learnTime'];
    lessonId = Utils.formatInt("lessonId", json);
    mediaId = Utils.formatInt("mediaId", json);
    url = json['url'];
    title = json['title'];
    type = json['type'];
  }

  @override
  String toString() {
    return 'LessonInfo{content: $content, courseId: $courseId, current_time: $current_time, file_num: $file_num, free: $free, learnTime: $learnTime, id: $id, lessonId: $lessonId, mediaId: $mediaId, number: $number, outUrl: $outUrl, status: $status, target: $target, title: $title, type: $type, url: $url, video_id: $video_id, videoInfo: $videoInfo}';
  }


}

class VideoInfos {
  List<VideoInfoItem> list;
  VideoItemInfo videoInfo;

  VideoInfos.fromJson(Map<String, dynamic> json){
    videoInfo = json['videoInfo'];
    List arr = json['list'];
    list = arr.map((m) => VideoInfoItem.fromJson(m)).toList();
  }
}

class VideoInfoItem {
  String definition; //'FD' | 'LD' | 'OD';
  String height; // 360 | 540 | 720;
  String playURL;
  int size;

  VideoInfoItem.fromJson(Map<String, dynamic> json){
    definition = json['Definition'];
    height = json['Height'];
    playURL = json['PlayURL'];
    size = Utils.formatInt("Size", json);
  }

}

class VideoItemInfo {
  String coverURL;
  String duration;
  String title;
  String videoId;


  VideoItemInfo.fromJson(Map<String, dynamic> json){
    coverURL = json['CoverURL'];
    duration = json['Duration'];
    title = json['Title'];
    videoId = json['VideoId'];
  }
}
