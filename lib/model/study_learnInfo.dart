class StudyLearnInfo {
  String title;
  String picture;
  int courseNum;
  int learnNum;
  int lastLessonID;

  StudyLearnInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    picture = json['picture'];
    courseNum = json['courseNum'];
    learnNum = json['learnNum'];
    lastLessonID = json['lastLessonID'];
  }
}
