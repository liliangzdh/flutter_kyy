///薄弱知识点
class KnowInfo {
  int id;
  String name;
  int subjectID;
  int importance;
  String updatedAt;
  String createdAt;

  KnowInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subjectID = json['subjectID'];
    importance = json['importance'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }
}
