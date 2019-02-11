
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../../model/userinfo.dart';

class UserInfoBloc  {


  UserInfo  userInfo = new UserInfo();
  var _subject = BehaviorSubject<UserInfo>();

  Stream<UserInfo> get stream => _subject.stream;
  UserInfo get value => userInfo;

  void setUerInfo(UserInfo  userInfo){
    _subject.add(userInfo);
  }


  void clear(){
//    _subject.
    _subject.add(new UserInfo());
  }

  void dispose() {
    _subject.close();
  }
}
