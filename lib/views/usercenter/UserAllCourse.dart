///
/// 我的课程
///
///
import "package:flutter/material.dart";
import 'package:flutterkaoyaya/api/net/useinfosrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/timeutils.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:flutterkaoyaya/dialog/TutorialOverlay.dart';
import 'package:flutterkaoyaya/dialog/arrayDialog.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/broadcasting.dart';
import '../../theme/Colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../common/logger.dart';

class UserAllCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserAllCourse();
  }
}

class _UserAllCourse extends State<UserAllCourse> {
  List<BroadCastingVideo> resultList = [];

  List<TopCate> topCateList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNet(0);
  }

  bool hasData = true;

  initNet(int id) async {
    AppResponse data = await UserInfoSrv.getUserCourses(id);
    if (data.code == 200) {
      List list = data.result['courseInfo'];
      List topList = data.result['topCateList'];
      List<BroadCastingVideo> videoList =
          list.map((m) => new BroadCastingVideo.fromJson(m)).toList();

      topCateList = topList.map((m) => new TopCate.fromJson(m)).toList();
      topCateList.insert(0, new TopCate(0, "全部"));
      setState(() {
        resultList = videoList;
        hasData = videoList.length > 0;
      });
    } else {
      ToastUtils.show(data.msg);
    }
  }

  int selectIndex = 0;

  renderFilter() {
    return new Container(
      alignment: AlignmentDirectional.centerEnd,
      child: RaisedButton(
          onPressed: () {
            showDialog(
                context: context, //BuildContext对象
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return new ArrayListSelectDialog(topCateList, selectIndex,
                      (int index) {
                    this.selectIndex = index;
                    initNet(topCateList[index].id);
                  });
                });

//            Navigator.of(context).push(TutorialOverlay());

//            Navigator.of(context).push<Widget>(PageRouteBuilder<Widget>(
//                opaque: true,
//                pageBuilder: (BuildContext context, _, __) {
//                  return Container(
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        new Container(
//                          height: Utils.getStateBarHeight(context),
//                          color: Colors.white,
//                        ),
//                        new Container(
//                          height: 56,
//                          color: Colors.red.withOpacity(0.1),
//                        ),
//
//
//                        new Container(
//                          color: Colors.white,
//                          width: Utils.getScreenWidth(context),
//                          alignment: AlignmentDirectional.center,
//                          child: new Text(
//                            "asas",
//                            style: TextStyle(
//                              fontSize: 18,
//                              decoration: TextDecoration.none,
//                              color: ColorConfig.color66,
//                            ),
//                          ),
//                          height: 30,
//                        )
//                      ],
//                    ),
//                    color: Colors.red.withOpacity(0.0),
//                  );
//                }));
          },
          color: Colors.white,
          clipBehavior: Clip.none,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(
                "筛选",
                style: new TextStyle(
                  fontSize: 18,
                  color: ColorConfig.baseColorPrime,
                ),
              ),
              Icon(
                Icons.filter_list,
                color: ColorConfig.baseColorPrime,
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("录播课"),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[renderFilter()],
      ),
      body: hasData
          ? ListView.builder(
              itemCount: resultList.length,
              itemBuilder: (BuildContext con, int num) {
                BroadCastingVideo item = resultList[num];
                double screenWidth = Utils.getScreen(context).width;
                int dateDiff = TimeUtils.getDateDiff(item.deadline);
                return new Container(
                  height: 161,
                  child: Column(
                    children: <Widget>[
                      Line(
                        height: 10,
                      ),
                      Container(
                        height: 110,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              item.picture,
                              width: 140,
                              height: 90,
                              fit: BoxFit.fill,
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        width: screenWidth - 140 - 30 - 10,
                                        child: new Text(
                                          item.title != null
                                              ? item.title
                                              : item.lessonTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 18),
                                        )),
                                    Container(
                                        width: screenWidth - 140 - 30 - 10,
                                        child: new Text(
                                          dateDiff > 0
                                              ? "已激活 | ${dateDiff.toString()} 天后到期"
                                              : "",
                                          style: TextStyle(
                                              color: ColorConfig.color8F),
                                        )),
                                    Container(
                                        width: screenWidth - 140 - 30 - 10,
                                        child: new Text(
                                          "有效期至${TimeUtils.formatTime(item.activationTime)}--${TimeUtils.formatTime(item.deadline)}",
                                          style: TextStyle(
                                              color: ColorConfig.color8F),
                                        )),
                                    SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: 5,
                                      size: 15.0,
                                      color: Colors.orange,
                                      borderColor: Colors.orange,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Line(
                        height: 1,
                        margin: EdgeInsets.only(left: 15, right: 15),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.person),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              item.progress == 0 ? "" : "已经学习${item.progress}%",
                              style:
                                  TextStyle(color: ColorConfig.baseColorPrime),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
          : Center(
              child: Text("暂无数据"),
            ),
    );
  }
}
