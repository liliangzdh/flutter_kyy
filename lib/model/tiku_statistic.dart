import 'package:flutterkaoyaya/model/practice_record.dart';

class TiKuStatistic {
  int totalQuestion=0;
  int doneQuestion=0;
  int rightQuestion=0;


  //是否有权限
  int access = 0;

  PracticeRecord practiceRecord;


  TiKuStatistic();

  TiKuStatistic.fromJson(Map<String, dynamic> json) {
    totalQuestion = json['totalQuestion'];
    doneQuestion = json['doneQuestion'];
    rightQuestion = json['rightQuestion'];
    practiceRecord = PracticeRecord.fromJson(json['practiceRecord']);
  }
}
