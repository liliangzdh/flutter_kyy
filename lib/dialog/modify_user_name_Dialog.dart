import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/useinfosrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/components/ColumnLine.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/model/TiKuSubject.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/userinfo.dart';
import 'package:flutterkaoyaya/provide/single_global_instance/appstate_bloc.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class ModifyUserName extends StatefulWidget {
  ModifyUserName();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ModifyUserName();
  }
}

class _ModifyUserName extends State<ModifyUserName> {
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.white.withOpacity(0.0),
          child: Center(
            child: SizedBox(
              width: Utils.getScreenWidth(context) - 40,
              height: 220,
              child: Container(
                margin: EdgeInsets.only(bottom: 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: Text(
                        "修改昵称",
                        style: TextStyle(
                          color: Colors.black45,
                          decoration: TextDecoration.none,
                          fontSize: 18,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          hintText: "修改昵称",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 18, color: Colors.black45),
                        onChanged: (username) {
                          this.username = username;
                        },
                        maxLines: 1,
                      ),
                      color: ColorConfig.colorEf,
                    ),
                    Line(
                      height: 1,
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Text(
                                  "取消",
                                  style: TextStyle(fontSize: 18),
                                ),
                                alignment: AlignmentDirectional.center,
                                height: 40,
                              ),
                            ),
                          ),
                          ColumnLine(
                            width: 1,
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                modifyUserName();
                              },
                              child: Container(
                                child: Text(
                                  "确定",
                                  style: TextStyle(fontSize: 18),
                                ),
                                alignment: AlignmentDirectional.center,
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  void modifyUserName() async {
    username = username.trim();
    if (username.length == 0) {
      ToastUtils.show("输入不能为空");
      return;
    }
    AppResponse app = await UserInfoSrv.modifyUserField(username);
    if (app.code == 200) {
      UserInfo userInfo = appStateBloc.getUserInfo();
      userInfo.nickname = username;
      appStateBloc.setUerInfo(userInfo);
      ToastUtils.show("修改成功");
    }
  }
}
