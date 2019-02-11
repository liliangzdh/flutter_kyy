class HomeDistribute {
  int id;
  String name;
  int resourceNum;
  List<Distribute> resource;

  HomeDistribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    resourceNum = json['resourceNum'];

    List list = json['resource'];
    resource = list.map((m) => new Distribute.fromJson(m)).toList();
  }
}

class Distribute {
  int id;

  int distributeID;

  String name;

  String pictureURL;

  String resourceType;

  int resourceID;

  String resourceName;
  String resourceURL;
  DistributeChild resource;
  String remark;

  Distribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    distributeID = json['distributeID'];
    name = json['name'];
    pictureURL = json['pictureURL'];
    resourceType = json['resourceType'];
    resourceID = json['resourceID'];
    resourceName = json['resourceName'];
    resourceURL = json['resourceURL'];
    remark = json['remark'];
    resource = DistributeChild.fromJson(json['resource']);
  }
}

class DistributeChild {
  String title;
  String subTitle;
  String picture;
  int peopleNum;
  int teacherUserID;
  String teacherName;

  DistributeChild.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['subTitle'];
    peopleNum = json['peopleNum'];
    teacherUserID = json['teacherUserID'];
    teacherName = json['teacherName'];
  }
}
