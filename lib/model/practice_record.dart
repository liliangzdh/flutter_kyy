class PracticeRecord {
  int subjectID;
  int practiceType;
  int practiceID;
  int practiceMode;

  PracticeRecord.fromJson(Map<String, dynamic> map) {
    subjectID = map['subjectID'];
    practiceType = map['practiceType'];
    practiceID = map['practiceID'];
    practiceMode = map['practiceMode'];
  }
}
