import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/timeutils.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/model/LiveBean.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class MyPreLiveItem extends StatefulWidget {
  final PreLiveBean bean;

  final Function function;

  MyPreLiveItem({@required this.bean, @required this.function})
      : assert(bean != null && function != null);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyPreLiveItem();
  }
}

class _MyPreLiveItem extends State<MyPreLiveItem> {
  bool isLive = false;

  Timer timer;

  @override
  void initState() {
    super.initState();
    initData();
    timer = Timer.periodic(Duration(seconds: 10), (_) {
      initData();
    });
  }

  initData() {
    PreLiveBean bean = widget.bean;
    isLive = TimeUtils.isLive(bean.startTime, bean.endTime);
    if (isLive) {
      timer?.cancel();
      timer = null;
    }
    if (mounted) {
      setState(() {
        setState(() {
          isLive = isLive;
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    PreLiveBean bean = widget.bean;
    return FlatButton(
      onPressed: (){
        this.widget.function(bean);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(
                  bean.picture,
                  height: 160,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
                Container(
                  child: Text(
                    isLive ? "正在直播" : "尚未开始",
                    style: TextStyle(color: isLive ? Colors.red : Colors.white),
                  ),
                  padding: EdgeInsets.all(5.0),
                  color: isLive ? ColorConfig.color6a : ColorConfig.color33,
                )
              ],
            ),
            Text(
              bean.lessonTitle,
              style: TextStyle(fontSize: 20, color: ColorConfig.color00),
            ),
            Padding(
              child: Text(
                "讲师：${bean.nickname}",
                style: TextStyle(fontSize: 16, color: Color(0xFF808080)),
              ),
              padding: EdgeInsets.only(top: 5),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(8),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(0),
    );
  }
}
