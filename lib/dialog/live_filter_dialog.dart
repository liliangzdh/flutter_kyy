import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/liveMicroSrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class LiveFilterSelectDialog extends StatefulWidget {
  final Function onPress;

  final int index;

  LiveFilterSelectDialog({this.index, this.onPress});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LiveFilterSelectDialog();
  }
}

class _LiveFilterSelectDialog extends State<LiveFilterSelectDialog> {
  int index = 0;

  List<TopCate> classArray;
  List<TopCate> liveArray;

  List<TopCate> data = [];

  void initNet() async {
    AppResponse appResponse =
        await LiveMicroSrv.getLiveIdAndClassIdByReplayLive();
    if (appResponse.code == 200) {
      List classArr = appResponse.result['classroomIds'];
      List liveArr = appResponse.result['liveIds'];

      classArray = classArr.map((m) {
        return TopCate.fromJson(m,0);
      }).toList();

      liveArray = liveArr.map((m) {
        return TopCate.fromJson(m,1);
      }).toList();


      data.add(new TopCate(0, "全部"));

      TopCate top = new TopCate(0, "班级");
      top.type = -1;
      data.add(top);
      data.addAll(classArray);
      TopCate course = new TopCate(0, "课程");
      course.type = -1;
      data.add(course);
      data.addAll(liveArray);

      setState(() {
        data = data;
      });
    } else {
      ToastUtils.show(appResponse.msg);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    initNet();
  }

  _buildItem(BuildContext context, int i) {
    if (data[i].type == -1) {
      //标题
      return Container(
        width: Utils.getScreenWidth(context),
        padding: EdgeInsets.only(left: 20),
        height: 50,
        alignment: AlignmentDirectional.centerStart,
        color: Colors.white,
        child: Container(
          alignment: AlignmentDirectional.center,
          child: Text(
            data[i].name,
            style: TextStyle(
                fontSize: 20,
                decoration: TextDecoration.none,
                color: ColorConfig.color66),
          ),
          width: 100,
          height: 40,
          decoration: BoxDecoration(
              color: ColorConfig.colorEf,
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: FlatButton(
          onPressed: () {
            setState(() {
              index = i;
            });
            widget.onPress(i,data[i]);
            Navigator.of(context).pop();
          },
          child: Container(
            width: Utils.getScreenWidth(context),
            alignment: AlignmentDirectional.center,
            child: Text(
              data[i].name,
              style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  color: index == i
                      ? ColorConfig.baseColorPrime
                      : ColorConfig.color99),
            ),
          )),
      height: 40,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 40),
        child: new Container(
          color: Colors.white.withOpacity(0.0),
          child: ListView.builder(
            itemBuilder: (bContext, index) {
              return _buildItem(context, index);
            },
            itemCount: data.length,
          ),
        ),
      ),
      onTapUp: (_) {
        Navigator.of(context).pop();
      },
    );
  }
}
