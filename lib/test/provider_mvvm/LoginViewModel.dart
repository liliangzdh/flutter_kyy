import 'package:flutter/cupertino.dart';
import 'package:flutterkaoyaya/api/net/loginSrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:provider/provider.dart';

/***
 *  provider  版的 mvvm 。
 ***/
class LoginViewModel with ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  int state = 0;

  void login() async {
    var username = usernameController.text;
    var password = passwordController.text;

    if (username == null || username.length == 0) {
      ToastUtils.show("请输入用户名!");
      return;
    }

    if (password == null || password.length == 0) {
      ToastUtils.show("请输入密码!");
      return;
    }

    state = 1; // 正在加载
    notifyListeners();
    await Future.delayed(Duration(seconds: 4));
    AppResponse response = await LoginSrv.accountLogin(
        {"username": username, "password": password});

    if (response.code == 200) {
      var token = response.result;

      state = 2;

      notifyListeners();

      return;
    }

    state = 3;
    notifyListeners();
  }
}
