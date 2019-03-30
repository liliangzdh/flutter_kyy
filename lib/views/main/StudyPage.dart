import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/ClassroomSrv.dart';
import 'package:flutterkaoyaya/api/net/TiKuSrv.dart';
import 'package:flutterkaoyaya/api/net/useinfosrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/components/HomeTitle.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:flutterkaoyaya/components/LiveItem.dart';
import 'package:flutterkaoyaya/components/MyAppBar.dart';
import 'package:flutterkaoyaya/components/UserCircleImage.dart';
import 'package:flutterkaoyaya/components/item_video_record.dart';
import 'package:flutterkaoyaya/components/tiku_cell.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
import 'package:flutterkaoyaya/model/LiveBean.dart';
import 'package:flutterkaoyaya/model/TiKuSubject.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/practice_record.dart';
import 'package:flutterkaoyaya/model/study_course.dart';
import 'package:flutterkaoyaya/model/study_learnInfo.dart';
import 'package:flutterkaoyaya/model/tiku_statistic.dart';
import 'package:flutterkaoyaya/provide/single_global_instance/appstate.dart';
import 'package:flutterkaoyaya/provide/single_global_instance/appstate_bloc.dart';
import 'package:flutterkaoyaya/store/share_preferences.dart';
import 'package:flutterkaoyaya/views/live/live.dart';
import 'package:flutterkaoyaya/views/main/page/study_menu.dart';
import 'package:flutterkaoyaya/views/main/page/study_nologin.dart';
import 'package:flutterkaoyaya/views/tiku/tiku.dart';
import 'package:flutterkaoyaya/views/usercenter/UserAllCourse.dart';
import '../../theme/Colors.dart';

class StudyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _StudyPage();
  }
}

class _StudyPage extends State<StudyPage> with AutomaticKeepAliveClientMixin {
  List<PreLiveBean> preLiveList = [];

  List<StudyResource> classList = [];
  List<StudyResource> courseList = [];

  StudyResource selectStudyResource = StudyResource(0, "");
  List<StudyLearnInfo> studyLearnInfoList;

  PracticeRecord practiceRecord;

  List<TiKuSubject> subjectList = [];

  TiKuStatistic tiKuStatistic = new TiKuStatistic();

  int manageModule = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    eventBus.on<LoginEvent>().listen((LoginEvent event) {
      initNet();
    });
    initNet();
  }

  initNet() async {
    selectStudyResource = await SharePreferenceUtils.getStudyClass();
    refresh();
  }

  getStudyResource() async {
    AppResponse appResponse = await UserInfoSrv.getStudyResource();
    if (appResponse.code != 200) {
      setState(() {});
      return;
    }
    List classArr = appResponse.result['class'];
    List courseArr = appResponse.result['course'];
    classList = classArr.map((m) => StudyResource.fromJson(m)).toList();
    courseList = courseArr.map((m) => StudyResource.fromJson(m)).toList();
    setState(() {});
  }

  refresh() {
    getStudyResource();
    getClassStudyResource();
  }

  getClassStudyResource() async {
    if (selectStudyResource.id == 0) {
      return;
    }

    AppResponse appResponse =
        await ClassroomMicroSrv.learnInfo(selectStudyResource.id);

    if (appResponse.code == 200) {

      manageModule = appResponse.result['class']['manageModule'];
      List normal = appResponse.result['normal'];
      if (normal is List) {
        studyLearnInfoList = normal.map((m) {
          return StudyLearnInfo.fromJson(m);
        }).toList();
      } else {
        studyLearnInfoList = [];
      }

      List liveList = appResponse.result['live'];

      if (liveList is List) {
        preLiveList = liveList.map((m) {
          return PreLiveBean.fromJson(m);
        }).toList();
      } else {
        liveList = [];
      }

      practiceRecord = PracticeRecord.fromJson(appResponse.result['exam']);

      List subList = appResponse.result['subjectList'];
      subjectList = subList.map((m) {
        return TiKuSubject.fromJson(m);
      }).toList();

      if (practiceRecord.subjectID > 0) {
        await getSubjectStatistic(practiceRecord.subjectID);
      }
      setState(() {
        studyLearnInfoList = studyLearnInfoList;
        preLiveList = preLiveList;
      });
    }
  }

  //获取数据统计
  getSubjectStatistic(int subjectID) async {
    AppResponse appResponse = await TiKuSrv.getSubjectStatistic(subjectID);
    if (appResponse.code == 200) {
      tiKuStatistic = TiKuStatistic.fromJson(appResponse.result);
    } else {
      tiKuStatistic = new TiKuStatistic();
    }
    return tiKuStatistic;
  }

  ///自定义头部
  initHeader(BuildContext context, String title, bool showLeftMenu) {
    return MAppBar(
      child: Container(
        color: ColorConfig.baseColorPrime,
        padding: EdgeInsets.only(top: Utils.getStateBarHeight(context)),
        child: Row(
          children: <Widget>[
            showLeft(showLeftMenu),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 80),
                alignment: AlignmentDirectional.center,
                child: Text(
                  title,
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

  showLeft(bool showLeft) {
    if (!showLeft) {
      return Container(width: 80);
    }

    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Container(
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
      onPressed: () {
        this.selectStudyResource = new StudyResource(0, "");
        setState(() {});
      },
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
    List<Map<String, dynamic>> data = [
      {
        'img': "assets/images/wenda1.png",
        "title": "班级问答",
        'url': '/i/class/${selectStudyResource.id}/qa/home'
      },
      {
        'img': "assets/images/tiku_write_huise.png",
        "title": "班级作业",
        "url": "/tiku/wap/classwork/${selectStudyResource.id}"
      },
      {
        "img": "assets/images/online.png",
        "title": "班级公告",
        "url": "/i/v2/study/class/${selectStudyResource.id}/news"
      },
    ];

    List<Widget> arrView = [];

    for (int i = 0; i < data.length; i++) {
      var bean = data[i];
      arrView.add(
        initStudyBottom(bean['img'], bean['title'], bean['url']),
      );
    }

    if(manageModule != 1){
      return Container();
    }

    return Container(
      height: 100,
      padding: EdgeInsets.only(top: 15),
      child: new Row(
        children: arrView,
      ),
    );
  }

  initStudyBottom(String imageUrl, String title, String url) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          RouteUtils.instance.goWebViewCheckLogin(context, url, true);
        },
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
        ),
      ),
    );
  }

  ///我的课程
  renderClass() {
    if (studyLearnInfoList == null || studyLearnInfoList.length == 0) {
      return new Container(
        child: Text("暂无记录"),
      );
    }
    return new ListView.builder(
        itemCount: studyLearnInfoList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return VideoRecordItem(info: studyLearnInfoList[index]);
        });
  }

  ///在线题库
  renderTiKuCell(String number, String text, String unit) {
    return Expanded(
      child: new Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                number,
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              Container(
                child: Text(
                  unit,
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
    if (preLiveList == null || preLiveList.length == 0) {
      return new Container(
        height: 40,
        alignment: AlignmentDirectional.center,
        child: Text(
          "暂无题库",
          style: TextStyle(fontSize: 30, color: ColorConfig.color99),
        ),
      );
    }
    return new Column(
      children: preLiveList.map((PreLiveBean bean) {
        return new LiveItem(bean, this.goLive);
      }).toList(),
    );
  }

  void goLive(PreLiveBean bean) {
    RouteUtils.instance
        .goLive2(context, 1, bean.startTime, bean.free, bean.mediaId, "live");
  }

  ///一切正常的页面。
  _buildMain(BuildContext context) {
    return Container(
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
                        showRightArrow: true, click: () {
                      RouteUtils.instance.go(context, new UserAllCourse());
                    }),
                    new Container(
                      child: new Center(child: renderClass()),
                      height: 144,
                      margin: EdgeInsets.only(bottom: 10),
                    ),

                    ///在学题库
                    new HomeTitle(
                      "在线题库",
                      rightText: "我的题库",
                      margin: EdgeInsets.only(top: 0, bottom: 0),
                      showRightArrow: true,
                      click: () {
                        RouteUtils.instance.go(context, TiKu());
                      },
                    ),

                    ///构建题库
                    _buildTiKu(),
                    Line(
                      height: 10,
                    ),

                    ///最近直播
                    new HomeTitle("最近直播",
                        rightText: "我的直播",
                        margin: EdgeInsets.only(top: 0, bottom: 0),
                        showRightArrow: true, click: () {
                      RouteUtils.instance.go(context, Live());
                    }),
                    renderLive(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  //构建题库
  _buildTiKu() {
    if (practiceRecord.subjectID > 0) {
      String subjectName = "";
      for (int i = 0; i < subjectList.length; i++) {
        if (practiceRecord.subjectID == subjectList[i].id) {
          subjectName = subjectList[i].name;
          break;
        }
      }

      double doneRate = tiKuStatistic.totalQuestion > 0
          ? tiKuStatistic.doneQuestion / tiKuStatistic.totalQuestion
          : 0;
      double rightRate = tiKuStatistic.doneQuestion > 0
          ? tiKuStatistic.rightQuestion / tiKuStatistic.doneQuestion
          : 0;
      return Column(
        children: <Widget>[
          new Container(
            child: Text(subjectName),
            alignment: AlignmentDirectional.center,
          ),
          new Container(
            child: Row(
              children: <Widget>[
                renderTiKuCell(doneRate.toString(), "完成率", "%"),
                renderTiKuCell(
                    tiKuStatistic.doneQuestion.toString(), "做题总数", "道"),
                renderTiKuCell(rightRate.toString(), "正确率", "%"),
              ],
            ),
          ),
          _buildKeepOnButton(),
        ],
      );
    }

    return TiKuCell(
      tikuList: this.subjectList,
      onPress: (int subjectID) async {
        //跳转到题库
        RouteUtils.instance.go(
          context,
          TiKu(
            subjectID: subjectID,
          ),
        );
      },
    );
  }

  //构建 题库 继续 按钮
  _buildKeepOnButton() {
    if (practiceRecord != null && practiceRecord.practiceType == 0) {
      return Container();
    }
    return Center(
      child: Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.only(bottom: 10),
        child: FlatButton(
          onPressed: () {
            RouteUtils.instance.tiKuKeepOn(context, tiKuStatistic);
          },
          color: ColorConfig.baseColorPrime,
          highlightColor: ColorConfig.baseColorPrime,
          shape: CircleBorder(),
          padding: EdgeInsets.all(0),
          child: Text(
            "继续",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  ///为登录的界面
  _buildNoLogin(BuildContext context, bool showNotLogin) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: 30,
            color: ColorConfig.baseColorPrime,
          ),
          Container(
            child: showNotLogin
                ? StudyNoLogin()
                : StudyMenu(classList, courseList,
                    (StudyResource item, int type) {
                    if (type == 1) {
                      selectStudyResource = item;
                      //todo 保存数据
                      SharePreferenceUtils.saveStudyClass(item.id, item.title);
                      setState(() {});
                      refresh();
                    } else if (type == 2) {
                      //
                      ToastUtils.show("跳转去课程");
                    } else {
                      ToastUtils.show("跳转去题库");
                    }
                  }),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: appStateBloc.stream,
      initialData: appStateBloc.value,
      builder: (BuildContext context, AsyncSnapshot<AppState> snapshot) {
        bool isLogin = snapshot.data.isLogin;
        String title = "学习中心";
        bool hasClass = hasSelectClassId();
        bool showLeftMenu = false;

        Widget bodyWidget;
        if (isLogin && hasClass) {
          title = selectStudyResource.title;
          showLeftMenu = true;
          bodyWidget = _buildMain(context);
        } else if (!isLogin) {
          title = "学习中心";
          showLeftMenu = false;
          bodyWidget = _buildNoLogin(context, true);
        } else {
          title = "选择要学习的产品";
          showLeftMenu = false;
          bodyWidget = _buildNoLogin(context, false);
        }
        return Scaffold(
          appBar: initHeader(context, title, showLeftMenu),
          body: bodyWidget,
        );
      },
    );
  }

  bool hasSelectClassId() {
    return selectStudyResource != null && selectStudyResource.id > 0;
  }

  renderList(BuildContext context) {
    return new Container(
      height: 500,
      color: Colors.red,
    );
  }
}
