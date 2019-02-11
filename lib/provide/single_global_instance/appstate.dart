import '../../model/userinfo.dart';
import '../../model/Category.dart';

class AppState {
  UserInfo userInfo;
  bool isLogin = false; //是否登录

  //考试科目
  List<Category> categoryList;
}
