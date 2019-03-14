import 'dart:async';
import '../../model/userinfo.dart';
import '../../model/Category.dart';
import 'appstate.dart';

//全局状态管理(单列模式)
class AppStateBloc {
  AppState appState = new AppState();

  var controller = StreamController<AppState>.broadcast();

  Stream<AppState> get stream => controller.stream;

  AppState get value => appState;

  setUerInfo(UserInfo userInfo) {
    appState.userInfo = userInfo;
    appState.isLogin = userInfo != null;
    controller.sink.add(appState);
  }

  getUserInfo() {
    return appState.userInfo;
  }

  logout() {
    setUerInfo(null);
  }

  //设置
  setCategory(List<Category> categoryList) {
    appState.categoryList = categoryList;
    controller.sink.add(appState);
  }

  dispose() {
    controller.close();
  }
}

AppStateBloc appStateBloc = AppStateBloc();
