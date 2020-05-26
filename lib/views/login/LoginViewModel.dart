import 'package:flutter/cupertino.dart';
import 'package:flutterkaoyaya/api/net/loginSrv.dart';
import 'package:flutterkaoyaya/api/net/useinfosrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/userinfo.dart';
import 'package:flutterkaoyaya/store/share_preferences.dart';

import '../base_mvvm/BaseViewModel.dart';
import '../../provide/single_global_instance/appstate_bloc.dart';


class LoginViewModel extends BaseViewModel<bool> {
  @override
  bool iniLoadingState() {
    return false;
  }

  final passwordController = TextEditingController();

  final usernameController = TextEditingController();

  ///登录
  login(BuildContext context) async {
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

    setLoading(true);
    await Future.delayed(Duration(seconds: 2));

    AppResponse response = await LoginSrv.accountLogin(
        {"username": username, "password": password});

    setLoading(false);

    if (response.code == 200) {
      var token = response.result;
      await SharePreferenceUtils.saveToken(token);
      response = await UserInfoSrv.getUserInfo();
      //获取用户数据
      if (response.code == 200) {
        var userInfo = UserInfo.fromJson(response.result);
        appStateBloc.setUerInfo(userInfo);
        //登录
        eventBus.fire(new LoginEvent(true));
        Navigator.of(context).pop();
        return;
      }
    }
    ToastUtils.show(response.msg);
  }
}
