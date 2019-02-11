import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import '../../provide/single_global_instance/appstate.dart';
import '../../views/usercenter/setting.dart';
import '../../dialog/LoadingDialog.dart';
import '../../components/Line.dart';
import '../../theme/Colors.dart';
import '../../components/UserCircleImage.dart';
import '../login/Login.dart';
import '../../model/userinfo.dart';
import '../../provide/single_global_instance/appstate_bloc.dart';
import '../../config/config.dart';

//new Image.network(
//"http://chart.ydniu.com/images/11ydj.jpg",
//width: 100,
//height: 100,
//),

//PopupMenuButton<String>(
//itemBuilder: (BuildContext context) => [
//PopupMenuItem<String>(value: "asas", child: Text("asas")),
//PopupMenuItem<String>(value: "asas", child: Text("asas")),
//]),
//
//new Text(_bodyStr),
//RaisedButton(
//child: Text("asaas"),
//onPressed: () {
//showDialogText(context);
//},
//)
class UserCenterPage extends StatefulWidget {
  @override
  _UserCenterPage createState() {
    // TODO: implement createState
    return new _UserCenterPage();
  }
}

class _UserCenterPage extends State<UserCenterPage> {
//  bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  showDialogText(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => new LoadingDialog(text: '你好12'));
  }

  renderCellText(String text) {
    return new Container(
        padding: const EdgeInsets.only(left: 20),
        child: new Text(text,
            style: TextStyle(color: ColorConfig.color33, fontSize: 18)));
  }

  go() {}

  renderCell(String text, IconData book, BuildContext context) {
    return new Container(
      child: new ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: new FlatButton(
            padding: EdgeInsets.only(left: 0),
            onPressed: () {
              print("--------------");
              RouteUtils.instance
                  .goWebView(context, Api.BASE_URL + "/i/user/profile",title: text);
            },
            child: Row(
              children: <Widget>[
                Icon(book, color: Color(0xff76C6F9)),
                renderCellText(text)
              ],
            )),
      ),
      height: 40,
      padding: const EdgeInsets.only(left: 10),
    );
  }

  renderList(BuildContext context) {
    return Column(
      children: <Widget>[
        renderCell("我的订单", Icons.book, context),
        Line(color: ColorConfig.colorE5),
        renderCell("我的考币", Icons.memory, context),
        Line(color: ColorConfig.colorE5),
        renderCell("我的推广", Icons.print, context),
        Line(
          height: 8,
          color: ColorConfig.colorEf,
        ),
        renderCell("我的优惠卷", Icons.print, context),
        Line(color: ColorConfig.colorE5),
        renderCell("消息中心", Icons.print, context),
        Line(color: ColorConfig.colorE5),
        renderCell("帮助和反馈", Icons.print, context),
        Line(height: 8, color: ColorConfig.colorEf),
        renderCell("设置", Icons.print, context),
        Container(
          child: FlatButton(
            onPressed: () {
              RouteUtils.instance.cleanCookies();
            },
            child: Text("清除网页的cookie"),
          ),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              RouteUtils.instance.getCookie();
            },
            child: Text("显示cookie"),
          ),
        )
      ],
    );
  }

  goLogin(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Login();
    }));
  }

  renderTopNoLogin(BuildContext context) {
    return [
      new Container(
          padding: EdgeInsets.only(left: 10),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        goLogin(context);
                      },
                      child: new Text("立即登录",
                          style: new TextStyle(
                              color: Colors.white, fontSize: 18))),
                ]),
              ]))
    ];
  }

  renderTopLogin(bool isLogin, BuildContext context, UserInfo userInfo) {
    if (!isLogin) {
      return renderTopNoLogin(context);
    }

    var nickname = userInfo.nickname;

    if (nickname == null || nickname.length == 0) {
      nickname = "学员";
    }

    return [
      new Container(
          padding: EdgeInsets.only(left: 10),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(children: <Widget>[
                  new Text(nickname,
                      style: new TextStyle(color: Colors.white, fontSize: 18)),
                  new Container(
                      margin: EdgeInsets.only(left: 16),
                      child: new Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                          new Text("修改昵称",
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 14))
                        ],
                      )),
                ]),
                new Container(
                    padding: EdgeInsets.only(top: 5),
                    child: new Text(userInfo.username,
                        style:
                            new TextStyle(color: Colors.white, fontSize: 14)))
              ])),
      Expanded(child: new Text("")),
      Container(
        child: new RaisedButton(
          color: ColorConfig.baseColorPrime,
          padding: EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          onPressed: () {},
          child: new Text(
            "个人资料",
            style: new TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        margin: EdgeInsets.only(right: 10),
      )
    ];
  }

  renderLogin(BuildContext context, UserInfo userInfo, bool isLogin) {
    return new Container(
      color: ColorConfig.baseColorPrime,
      child: new Row(children: <Widget>[
        new UserCircleImage(
            imgUrl: userInfo == null ? "" : userInfo.avatar,
            margin: EdgeInsets.only(left: 10)),
        new Expanded(
            child:
                new Row(children: renderTopLogin(isLogin, context, userInfo)))
      ]),
      padding: EdgeInsets.only(bottom: 40),
      height: 90,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("个人中心", style: new TextStyle(color: Colors.white)),
          backgroundColor: ColorConfig.baseColorPrime),
      body: new Container(
        child: new Stack(children: <Widget>[
          new StreamBuilder(
            stream: appStateBloc.stream,
            initialData: appStateBloc.value,
            builder: (BuildContext context, AsyncSnapshot<AppState> snapshot) {
              UserInfo data = snapshot.data.userInfo;
              return renderLogin(context, data, snapshot.data.isLogin);
            },
          ),
          new Container(
            margin: EdgeInsets.only(top: 70),
            decoration: new ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)))),
            child: new Column(
              children: <Widget>[
                Container(
                  child: renderList(context),
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(child: new Container(color: ColorConfig.colorF3)),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class Chose extends PopupMenuEntry<String> {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

  @override
  // TODO: implement height
  double get height => null;

  @override
  bool represents(value) {
    // TODO: implement represents
    return null;
  }
}
