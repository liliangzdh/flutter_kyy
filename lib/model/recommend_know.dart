import 'package:flutterkaoyaya/model/know_info.dart';

class RecommendKnows {
  List<KnowInfo> list;
  int count;
  int type;

  RecommendKnows.fromJson(Map<String, dynamic> json) {
    List arr = json['list'];
    list = arr.map((m) {
      return KnowInfo.fromJson(m);
    }).toList();
    type = json['type'];
    count = json['count'];
  }
}
