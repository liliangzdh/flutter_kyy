import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class StudyNoLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _StudyNoLogin();
  }
}

class _StudyNoLogin extends State<StudyNoLogin> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/images/kaoyaya.png"),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "登陆后可学习已经购买的产品哦~",
            style: TextStyle(color: Color(0xFF949ba7), fontSize: 16),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 18),
          child: FlatButton(
            onPressed: () {
              RouteUtils.instance.goLogin(context);
            },
            color: ColorConfig.baseColorPrime,
            highlightColor: ColorConfig.baseColorPrime,
            child: Text(
              "立即登录",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          width: 160,
          height: 40,
        )
      ],
    ));
  }
}
