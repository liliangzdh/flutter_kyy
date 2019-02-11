
import 'package:flutter/material.dart';
import '../../model/app_response.dart';
import '../../provide/single_global_instance/appstate_bloc.dart';
import '../../common/Toast.dart';
import '../../components/Line.dart';
import '../../theme/Colors.dart';
import '../../model/userinfo.dart';
import '../../store/share_preferences.dart';
import '../../api/net/loginSrv.dart';
import '../../api/net/useinfosrv.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _Login();
  }
}

class _Login extends State<Login> {
  String username;
  String password;

  ///登录
  login() async {
    if (username == null || username.length == 0) {
      ToastUtils.show("请输入用户名!");
      return;
    }

    if (password == null || password.length == 0) {
      ToastUtils.show("请输入密码!");
      return;
    }

    AppResponse response = await LoginSrv.accountLogin(
        {"username": username, "password": password});

    if (response.code == 200) {
      var token = response.result;
      await SharePreferenceUtils.saveToken(token);
      response = await UserInfoSrv.getUserInfo();
      //获取用户数据
      if (response.code == 200) {
        var userInfo = UserInfo.fromJson(response.result);
        appStateBloc.setUerInfo(userInfo);
        Navigator.of(context).pop();
        return;
      }
    }
    ToastUtils.show(response.msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("登录"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: new SingleChildScrollView(
            child: new Container(
          padding: EdgeInsets.only(
            top: 60,
            left: 40,
            right: 40,
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/logo.png", width: 80, height: 80),
              Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: <Widget>[
                      new TextField(
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.all(0.0),
                          icon:
                              Icon(Icons.phone_android, color: Colors.black38),
                          border: InputBorder.none,
                          hintText: "请输入账户",
                        ),
                        onChanged: (username) {
                          this.username = username;
                        },
                      ),
                      Line(
                        color: ColorConfig.colorEf,
                        height: 1,
                        margin: EdgeInsets.only(top: 6),
                      )
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      new TextField(
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.all(0.0),
                          icon: Icon(Icons.work, color: Colors.black38),
                          border: InputBorder.none,
                          hintText: "请输入密码",
                        ),
                        onChanged: (text) {
                          this.password = text;
                        },
                      ),
                      Line(
                        color: ColorConfig.colorEf,
                        height: 1,
                        margin: EdgeInsets.only(top: 6),
                      )
                    ],
                  )),
              new Container(
                height: 46,
                margin: EdgeInsets.only(top: 20),
                child: new ConstrainedBox(
                    constraints: new BoxConstraints.expand(),
                    child: new RaisedButton(
                      color: ColorConfig.baseColorPrime,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(23))),
                      onPressed: () {
                        login();
                      },
                      child: new Text(
                        "登录",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              )
            ],
          ),
        )));
  }
}
