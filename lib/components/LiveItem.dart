import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/timeutils.dart';
import '../model/LiveBean.dart';
import '../theme/Colors.dart';
import 'dart:async';
import '../common/Toast.dart';

class LiveItem extends StatefulWidget {
  final PreLiveBean bean;

  final Function function;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LiveItem();
  }

  LiveItem(this.bean, this.function);
}

class _LiveItem extends State<LiveItem> {
  String time = "";
  bool isLiveShow = false;

  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String startTime = widget.bean.startTime;
    formatTime(startTime);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this._timer?.cancel();
  }

  formatTime(String startTime) {
    isLiveShow = TimeUtils.isLive(widget.bean.startTime, widget.bean.endTime);
    Map<String, dynamic> data = TimeUtils.formatSampleTime(startTime);
    if (data['duration'].inSeconds > 0) {
      time = data['timeString'];
      //开启倒计时
      _timer?.cancel();
      _timer = null;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        cupTime();
      });
    } else {
      time = "00时00分00秒";
    }
  }

  cupTime() {
    isLiveShow = TimeUtils.isLive(widget.bean.startTime, widget.bean.endTime);
    Map<String, dynamic> data =
        TimeUtils.formatSampleTime(widget.bean.startTime);
    if (data['duration'].inSeconds > 0) {
      time = data['timeString'];
    } else {
      time = "00时00分00秒";
      _timer?.cancel();
      _timer = null;
      ToastUtils.show("倒计时结束");
    }
    setState(() {
      time = time;
      isLiveShow = isLiveShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: Container(
        height: 100,
        child: Row(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.bean.picture),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: ColorConfig.colorF3,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            widget.bean.lessonTitle,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          new Text(
                            widget.bean.nickname,
                            maxLines: 1,
                            style: TextStyle(
                              color: ColorConfig.color99,
                              fontSize: 16,
                            ),
                          ),
                          new Text(
                            isLiveShow ? "直播中" : time,
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorConfig.color99,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLiveShow
                        ? new Icon(
                            Icons.live_tv,
                            color: Colors.redAccent,
                          )
                        : Container(
                            height: 0,
                          ),
                    renderLiveState(isLiveShow),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        widget.function(widget.bean);
      },
    );
  }

  renderLiveState(bool isLive) {
    BoxDecoration boxDecoration;
    if (isLive) {
      boxDecoration = new BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      );
    } else {
      boxDecoration = new BoxDecoration(
        border: new Border.all(width: 1.0, color: Colors.blue),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      );
    }

    return new Container(
      height: 50,
      width: 80,
      alignment: AlignmentDirectional.center,
      decoration: boxDecoration,
      child: new Text(
        isLive ? "点击听课" : "点击预约",
        style:
            TextStyle(color: isLive ? Colors.white : Colors.blue, fontSize: 15),
      ),
    );
  }
}
