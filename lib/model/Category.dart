class Category {
  int id;
  String name;


  Category(this.id,this.name);


  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
