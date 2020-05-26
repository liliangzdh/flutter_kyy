import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:flutterkaoyaya/components/loading.dart';
import 'package:flutterkaoyaya/test/bloc_mvvm/LoginViewModel.dart';
import '../../theme/Colors.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Login();
  }
}

class _Login extends State<Login> {
  LoginViewModel viewModel = LoginViewModel();

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 键盘是否 弹窗
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
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
                          )
                        ),
                      ),
                      Line(
                        height: 1,
                        color: ColorConfig.colorf4f4f4,
                      ),
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
                          onPressed: () {
                            viewModel.login(context);
                          },
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


              StreamBuilder<bool>(
                stream: viewModel.outputLoadingStateStream,
                initialData: viewModel.loadingState,
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  print('$data');
                  return Loading(data,text: '登录中...',);
                },
              ),
            ],
          )),
    );
  }
}
