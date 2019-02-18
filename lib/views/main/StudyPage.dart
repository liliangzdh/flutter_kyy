import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/components/HomeTitle.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:flutterkaoyaya/components/LiveItem.dart';
import 'package:flutterkaoyaya/components/MyAppBar.dart';
import 'package:flutterkaoyaya/components/UserCircleImage.dart';
import 'package:flutterkaoyaya/model/LiveBean.dart';
import 'package:flutterkaoyaya/views/usercenter/UserAllCourse.dart';
import '../../theme/Colors.dart';

class StudyPage extends StatelessWidget {

  final List<PreLiveBean> preLiveList = [];



  ///自定义头部
  initHeader(BuildContext context) {
    return MAppBar(
      child: Container(
        color: ColorConfig.baseColorPrime,
        padding: EdgeInsets.only(top: Utils.getStateBarHeight(context)),
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.dehaze,
                    color: Colors.white,
                    size: 24,
                  ),
                  Container(
                    child: Text(
                      "切换",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 2, bottom: 2),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 80),
                alignment: AlignmentDirectional.center,
                child: Text(
                  "初级通关班",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  initTopBottom(String text) {
    return Expanded(
      child: new Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: ColorConfig.baseColorPrime,
          border: Border.all(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  initStudy() {
    return Container(
      height: 100,
      padding: EdgeInsets.only(top: 15),
      child: new Row(
        children: <Widget>[
          initStudyBottom("assets/images/wenda1.png", "班级问答"),
          initStudyBottom("assets/images/tiku_write_huise.png", "班级作业"),
          initStudyBottom("assets/images/online.png", "班级公告")
        ],
      ),
    );
  }

  initStudyBottom(String imageUrl, String title) {
    return new Expanded(
        child: Column(
      children: <Widget>[
        Image.asset(
          imageUrl,
          width: 60,
          height: 60,
          scale: 0.8,
        ),
        Text(
          title,
          style: TextStyle(color: ColorConfig.baseColorPrime),
        ),
      ],
    ));
  }

  ///我的课程
  renderClass() {
//    if (resultList.length == 0) {
//      return new Container();
//    }

    var goodData = [1, 2, 3, 4, 5, 6];
    return new ListView.builder(
        itemCount: goodData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return new Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: ColorConfig.colorEf,
                borderRadius: BorderRadius.all(new Radius.circular(5)),
              ),
              child: FlatButton(
                  onPressed: () {},
                  highlightColor: ColorConfig.colorE5,
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: new Column(children: <Widget>[
                    new Container(
                        child: new Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: new Stack(
                            children: <Widget>[
                              new CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://vuejs.bootcss.com/images/logo.png"),
                                  radius: 30),
                              Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ],
                            alignment: AlignmentDirectional.center,
                          ),
                        ),
                        height: 80),
                    new Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text("班级常见问题",
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConfig.color33,
                            ))),
                    new Container(
                      child: Text("已经10%",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConfig.color66,
                          )),
                      margin: const EdgeInsets.only(top: 5),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    SizedBox(
                      height: 3.0,
                      child: new LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: ColorConfig.colorEf,
                      ),
                    ),
                  ])),
              height: 120,
              width: 240);
        });
  }

  ///在线题库
  renderTiKuCell(int number, String text) {
    return Expanded(
      child: new Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                number.toString(),
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              Container(
                child: Text(
                  "%",
                  style: TextStyle(fontSize: 14, color: ColorConfig.color99),
                ),
                margin: EdgeInsets.only(top: 6),
              ),
            ],
          ),
          Text(text),
        ],
      ),
    );
  }


  ///直播列表
  renderLive() {
//    if (preLiveList == null || preLiveList.length == 0) {
//      return new Container(
//        height: 200,
//      );
//    }

    return new Column(
      children: preLiveList.map((PreLiveBean bean) {
        return new LiveItem(bean);
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: initHeader(context),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            color: ColorConfig.baseColorPrime,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new UserCircleImage(
                      imgUrl: "",
                      margin: EdgeInsets.only(
                        left: 10,
                      ),
                    ),
                    Container(
                      child: Text(
                        "用户名",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      margin: const EdgeInsets.only(left: 10),
                    )
                  ],
                ),

                //3个顶部按钮
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      initTopBottom("录播课"),
                      initTopBottom("题库"),
                      initTopBottom("直播回放"),
                    ],
                  ),
                  height: 60,
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 20,
                  color: ColorConfig.baseColorPrime,
                ),
                Container(
                  decoration: new ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18)))),
                  child: ListView(
                    children: <Widget>[
                      ///班级3个按钮
                      initStudy(),

                      Line(
                        height: 10,
                      ),

                      ///在学课程
                      new HomeTitle("精品体验课",
                          rightText: "我的课程",
                          margin: EdgeInsets.only(top: 0, bottom: 0),
                          showRightArrow: true,
                          click: () {
                            RouteUtils.instance.go(context,new UserAllCourse());
                          }),
                      new Container(
                        child: new Center(child: renderClass()),
                        height: 144,
                        margin: EdgeInsets.only(bottom: 10),
                      ),

                      ///在学题库
                      new HomeTitle("在线题库",
                          rightText: "我的题库",
                          margin: EdgeInsets.only(top: 0, bottom: 0),
                          showRightArrow: true,
                          click: () {}),
                      new Container(
                        child: Text("经济法基础"),
                        alignment: AlignmentDirectional.center,
                      ),

                      new Container(
                        child: Row(
                          children: <Widget>[
                            renderTiKuCell(0, "完成率"),
                            renderTiKuCell(0, "做题总数"),
                            renderTiKuCell(0, "正确率"),
                          ],
                        ),
                      ),

                      Center(
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.only(bottom: 10),
                          child: FlatButton(
                              onPressed: () {},
                              color: ColorConfig.baseColorPrime,
                              highlightColor: ColorConfig.baseColorPrime,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "继续",
                                style: TextStyle(color: Colors.white,fontSize: 16),
                              )),
                        ),
                      ),

                      Line(
                        height: 10,
                      ),

                      ///最近直播
                      new HomeTitle("最近直播",
                          rightText: "我的直播",
                          margin: EdgeInsets.only(top: 0, bottom: 0),
                          showRightArrow: true,
                          click: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
      backgroundColor: Colors.white,
    );
  }

  renderList(BuildContext context) {
    return new Container(
      height: 500,
      color: Colors.red,
    );
  }
}
