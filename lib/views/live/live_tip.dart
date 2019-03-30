import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/liveMicroSrv.dart';
import 'package:flutterkaoyaya/api/net/live_srv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/common/timeutils.dart';
import 'package:flutterkaoyaya/components/loading.dart';
import 'package:flutterkaoyaya/dialog/LoadingDialog.dart';
import 'package:flutterkaoyaya/enum/liveTipState.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
import 'package:flutterkaoyaya/model/LiveBean.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/live_info.dart';
import 'package:flutterkaoyaya/provide/single_global_instance/appstate_bloc.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';
import 'package:flutterkaoyaya/views/login/Login.dart';

class LiveTip extends StatefulWidget {
  final int liveId;

  LiveTip(this.liveId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LiveTip();
  }
}

class _LiveTip extends State<LiveTip> {
  LiveInfo liveInfo;

  LiveState liveState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    eventBus.on<LoginEvent>().listen((LoginEvent event) {
      init();
    });
  }

  Timer _timer;
  String time = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this._timer?.cancel();
  }

  formatTime(String startTime) {
    Map<String, dynamic> map = TimeUtils.formatSampleTime(startTime);
    if (map['duration'].inSeconds > 0) {
      time = map['timeString'];
      //开启倒计时
      _timer?.cancel();
      _timer = null;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        cupTime(startTime);
      });
    } else {
      time = "00:00:00";
    }
  }

  cupTime(String startTime) {
    Map<String, dynamic> map = TimeUtils.formatSampleTime2(startTime);
    if (map['duration'].inSeconds > 0) {
      time = map['timeString'];
    } else {
      time = "00:00:00";
      _timer?.cancel();
      _timer = null;
      ToastUtils.show("倒计时结束");
      getToken();
    }
    setState(() {
      time = time;
    });
  }

  _buildBody() {
    if (liveInfo == null || liveState == null) {
      return Loading();
    }
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            child: Text(
              liveInfo.courseName,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            padding: EdgeInsets.only(top: 20),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14, bottom: 14),
            child: Text(
              liveInfo.title,
              style: TextStyle(
                color: ColorConfig.color20,
                fontSize: 18,
              ),
            ),
          ),
          _buildImage(),
          Padding(
            child: Text(
              "${liveInfo.nickname} ${liveInfo.startTime}",
              style: TextStyle(
                color: ColorConfig.color88,
                fontSize: 16,
              ),
            ),
            padding: EdgeInsets.only(top: 5),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              time,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Text(
            liveState.countDownTip,
            style: TextStyle(
              color: ColorConfig.color99,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            child: Text(
              liveState.bottomTip,
              style: TextStyle(
                color: ColorConfig.color20,
                fontSize: 16,
              ),
            ),
            padding: EdgeInsets.only(bottom: 4),
          ),
          _buildBottom(),
        ],
      ),
    );
  }

  _buildImage() {
    return Container(
      width: 280,
      height: 180,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(liveInfo.picture),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
            width: double.infinity,
            height: double.infinity,
            alignment: AlignmentDirectional.center,
            child: Text(
              "${liveState.topTip}\n- ${liveState.code} -",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildBottom() {
    return Container(
      color: ColorConfig.color01,
      width: double.infinity,
      child: FlatButton(
        onPressed: () {
          if (liveState.routeName == "home") {
            Navigator.of(context).pop();
          } else if (liveState.routeName == "login") {
            RouteUtils.instance.go(context, Login());
          } else if (liveState.routeName == "live") {
            //立即进去 直播
            RouteUtils.instance.goNowLive(accessToken, liveInfo.title);
          }
        },
        child: Text(
          liveState.backTo,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("直播提醒"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  String accessToken = "";

  void init() async {
    AppResponse app = await LiveSrv.getLiveInfo(widget.liveId.toString());
    if (app.code != 200) {
      ToastUtils.show(app.msg);
      setState(() {
        liveState =  LiveTipStateEnum.noNet;
        liveInfo= new LiveInfo();
      });
      return;
    }
    liveInfo = LiveInfo.fromJson(app.result);
    formatTime(liveInfo.startTime);
    getToken();
  }

  getToken() async {
    AppResponse app =
        await LiveMicroSrv.getAccessToken(widget.liveId.toString());
    if (app.code == 200) {
      accessToken = app.result['accessToken'];
      liveState =
          TimeUtils.judgeState(appStateBloc.value.isLogin, liveInfo.startTime);
    }else if(app.code == 406){
      liveState = LiveTipStateEnum.notBuy;
    }else if(app.code == 407){
      liveState = LiveTipStateEnum.outOfService;
    }else if(app.code == 401){
      liveState = LiveTipStateEnum.liveNotStart;
    }else if(app.code == 405){
      liveState = LiveTipStateEnum.liveNotStart;
    }

    setState(() {
      liveState = liveState;
      liveInfo = liveInfo;
    });
    //如果有权限，
    if (liveState.routeName == "live") {
      //立即进去 直播
      RouteUtils.instance.goNowLive(accessToken, liveInfo.title);
    }
  }
}
