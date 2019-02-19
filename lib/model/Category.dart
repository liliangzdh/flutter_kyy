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

  TopCate(this.id,this.name);


  TopCate.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    name = json['name'];
  }
}