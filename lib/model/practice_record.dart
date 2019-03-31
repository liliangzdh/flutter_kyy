class PracticeRecord {
  int subjectID=0;
  int practiceType=0;
  int practiceID=0;
  int practiceMode=0;


  PracticeRecord();

  PracticeRecord.fromJson(Map<String, dynamic> map) {
    subjectID = map['subjectID'];
    practiceType = map['practiceType'];
    practiceID = map['practiceID'];
    practiceMode = map['practiceMode'];
  }
}
