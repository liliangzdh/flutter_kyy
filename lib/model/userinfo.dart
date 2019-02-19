class UserInfo {


  String avatar ="";
  String birthday;
  String birthmonth;
  String birthyear;
  int currentExamType; // 用户当前的考试类型
  String email;
  String mobile;
  int status; // 0公众号来的新用户 1老用户
  String name;
  String nickname = "";
  String qq;
  int sex;
  String username = "";
  int uid;
  String regDate;


  UserInfo();

  UserInfo.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'],
        birthday = json['birthday'],
        birthmonth = json['birthmonth'],
        birthyear = json['birthyear'],
        currentExamType = json['currentExamType'],
        email = json['email'],
        mobile = json['mobile'],
//        status = json['status'],
        nickname = json['nickname'],
        name = json['name'],
        qq = json['qq'],
        sex = json['sex'],
        username = json['username'],
        uid = json['uid'],
        regDate = json['regDate'];

}
