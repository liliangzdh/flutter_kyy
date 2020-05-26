import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:provider/provider.dart';
import '../../theme/Colors.dart';

import 'LoginViewModel.dart';

class Login extends StatelessWidget {
  final loinViewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: loinViewModel,
      child: LoginWidget(),
    );
  }
}

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 键盘是否 弹窗
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;

    // 获取
    final viewModel = Provider.of<LoginViewModel>(context);

    print('30-------------');

    return Scaffold(
      appBar: AppBar(
        title: Text("登录mvvm测试"),
        elevation: 0,
      ),
      body: Container(
          color: ColorConfig.colorfff,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '账户登录',
                        style: TextStyle(
                            color: ColorConfig.color33,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: TextField(
                          maxLines: 1,
                          controller: viewModel.usernameController,
                          decoration: InputDecoration(
                            hintText: '请输入账户',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: ColorConfig.color_ccc),
                          ),
                        ),
                      ),
                      Line(
                        height: 1,
                        color: ColorConfig.colorf4f4f4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          maxLines: 1,
                          controller: viewModel.passwordController,
                          decoration: InputDecoration(
                            hintText: '请输入密码',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: ColorConfig.color_ccc),
                          ),
                        ),
                      ),
                      Line(
                        height: 1,
                        color: ColorConfig.colorf4f4f4,
                      ),
                      Text(viewModel.state == 0
                          ? '初始化'
                          : viewModel.state == 1 ? '正在加载' : '加载成功'),
                      Container(
                        width: double.infinity,
                        height: 150,
                        padding: EdgeInsets.only(top: 100),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          color: ColorConfig.baseColor,
                          elevation: 0,
                          highlightElevation: 0,
                          disabledElevation: 0,
                          onPressed: viewModel.login,
                          child: Text(
                            '登录',
                            style: TextStyle(
                                color: ColorConfig.colorfff, fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                          height: 40,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: double.infinity,
                          child: Row(children: <Widget>[
                            Text('忘记密码'),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Text('立即注册'),
                          ])),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Offstage(
                    offstage: isKeyboardShowing,
                    child: Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '登录即表示同意',
                            style: TextStyle(
                              fontSize: 10,
                              color: ColorConfig.color_909090,
                            ),
                          ),
                          Text(
                            '《考呀呀用户协议》',
                            style: TextStyle(
                              fontSize: 10,
                              color: ColorConfig.color33,
                            ),
                          ),
                          Text(
                            '及',
                            style: TextStyle(
                              fontSize: 10,
                              color: ColorConfig.color_909090,
                            ),
                          ),
                          Text(
                            '《隐私条款》',
                            style: TextStyle(
                              fontSize: 10,
                              color: ColorConfig.color33,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
