import 'package:flutterkaoyaya/common/utils.dart';

class Category {
  int id;
  String name;

  bool isSelect;

  Category(this.id,this.name);


  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}


class TopCate {
  int id;
  String name;

  bool isSelect = false;


  int type;  //0 为班级 1位课程，

  TopCate(this.id,this.name);



  TopCate.fromJson(Map<String, dynamic> json,int type) {
    id = Utils.formatInt("id", json);
    name = json['name'];
    this.type = type;
    if(name==null || name.length == 0){
      //在
      name = json['title'];
    }
  }
}