class CourseInfo {
  String about;
  int buyAble;
  int copyId;
  double discountPrice;
  int expiryDay;
  String fileNum;
  int id;
  int lastLesson; // 上次学习课时id
  int lessonLearnNum =0; // 学习数
  String oem;
  String picture;
  double price;
  int studentNum=0;
  String subtitle;
  String title ="";
  String url;
  String type; //'live' | 'normal' | 'exam';
  String videoId;
  String videoUrl;
  String playURL;
  int subjectID;


  int access=0;


  CourseInfo();

  CourseInfo.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    buyAble = int.parse(json['buyable']);
    copyId = int.parse(json['copyId']);
    discountPrice = double.parse(json['discountPrice']);
    expiryDay = json['expiryDay'] == null?0:int.parse(json['expiryDay']);
    fileNum = json['file_num'];
    id = int.parse(json['id']);
    lastLesson = json['lastLesson']==null?0: int.parse(json['lastLesson']);
    lessonLearnNum = json['lessonLearnNum'] == null?0:int.parse(json['lessonLearnNum']);
    picture = json['picture'];
    price = double.parse(json['price']);
    studentNum = json['studentNum'] == null ?0:int.parse(json['studentNum']);
    title = json['title'];
    url = json['url'];
    type = json['type'];
    videoId = json['videoId'];
    videoUrl = json['videourl'];
    playURL = json['playURL'];
    subjectID = json['subjectID']==null?0:int.parse(json['subjectID']);
  }
}
