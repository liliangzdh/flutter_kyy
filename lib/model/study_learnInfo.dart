class StudyLearnInfo {

  int id;
  String title;
  String picture;
  int courseNum;
  int learnNum;
  int lastLessonID;

  StudyLearnInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    picture = json['picture'];
    courseNum = json['courseNum'];
    learnNum = json['learnNum'];
    lastLessonID = json['lastLessonID'];
  }
}
