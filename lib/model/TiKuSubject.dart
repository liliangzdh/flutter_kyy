class TiKuSubject {
  int id;

  String name;
  int parentID;
  int isSprintOpen;

  TiKuSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentID = json['parentID'];
    isSprintOpen = json['isSprintOpen'];
  }
}
