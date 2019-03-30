import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/TiKuSrv.dart';
import 'package:flutterkaoyaya/api/net/useinfosrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/components/ColumnLine.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:flutterkaoyaya/config/config.dart';
import 'package:flutterkaoyaya/dialog/tiku_select_Dialog.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/model/TiKuSubject.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/know_info.dart';
import 'package:flutterkaoyaya/model/practice_record.dart';
import 'package:flutterkaoyaya/model/recommend_know.dart';
import 'package:flutterkaoyaya/model/tiku_statistic.dart';
import 'package:flutterkaoyaya/store/share_preferences.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

enum PracticeType {
  PracticeChapter, //章练习
  PracticeSection, //节练习
  PracticeKnowledge, //知识点练习
  PracticeExamMock, //模拟试卷练习
  PracticeHomeWork, //班级作业练习
}

class TiKu extends StatefulWidget {
  final int examType;
  final int subjectID;

  TiKu({this.subjectID, this.examType});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TiKu();
  }
}

class _TiKu extends State<TiKu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.subjectID!= null && widget.subjectID >0) {
      //说明 有传递的东西。
      initNetFromParams(widget.subjectID);
    } else {
      initNet();
    }
  }

  List<TiKuSubject> tikuList = [];
  TiKuSubject curSubject = TiKuSubject("");

  initNet() async {
    Category bean = await SharePreferenceUtils.getCategory();
    if (bean != null && bean.id > 0) {
      //说明存在这个栏
      AppResponse response =
          await UserInfoSrv.getDistributeSubject(bean.id.toString());
      int examID = response.result[0]['id'];
      initNetGetSubjects(examID, 0);
    }
  }

  initNetFromParams(int subjectID) async {
    AppResponse appResponse = await TiKuSrv.getSubjectInfo(subjectID);
    int parentID = appResponse.result['info']['parentID'];
    appResponse = await TiKuSrv.getSubjectInfo(parentID);
    int examID = appResponse.result['info']['id'];
    initNetGetSubjects(examID, subjectID);
  }

  initNetGetSubjects(int examID, int subjectID) async {
    AppResponse response = await TiKuSrv.getSubjects(examID);
    if (response.code != 200) {
      return;
    }
    List list = response.result['subjects'];
    tikuList = list.map((m) => TiKuSubject.fromJson(m)).toList();
    if (subjectID > 0) {
      for(int i=0;i<tikuList.length;i++){
        if(tikuList[i].id == subjectID){
          curSubject = tikuList[i];
          selectIndex = i;
          break;
        }
      }
    } else {
      curSubject = tikuList[0];
    }
    refresh();
    getData();
  }

  RecommendKnows recommendKnows;
  TiKuStatistic tiKuStatistic = TiKuStatistic();

  getData() async {
    int subjectID = curSubject.id;
    AppResponse appResponse = await TiKuSrv.getRecommendKnows(subjectID);
    if (appResponse.code == 200) {
      recommendKnows = RecommendKnows.fromJson(appResponse.result);
    }
    appResponse = await TiKuSrv.getSubjectStatistic(subjectID);
    if (appResponse.code == 200) {
      tiKuStatistic = TiKuStatistic.fromJson(appResponse.result);
    }

    //是否开放押题卷
    appResponse = await TiKuSrv.checkSubjectAccess(subjectID);
    if (appResponse.code == 200) {
      tiKuStatistic.access = appResponse.result;
    }
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("题库"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          _buildMenu(),
          _buildTiKuChart(),
          _buildTiKuButton(),
          Line(
            height: 10,
          ),
          _buildTitle("题库类型"),
          _buildTiKuType(),
          Line(
            height: 10,
          ),
          _buildTitle(
              "${recommendKnows == null ? "" : recommendKnows.type == 1 ? "推荐" : "薄弱"}知识点"),
          _buildRecommend()
        ],
      ),
    );
  }

  _buildTitle(String title) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
    );
  }

  int selectIndex = 0;

  refresh() {
    setState(() {});
  }

  _buildMenu() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 4,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            curSubject.name,
            style: TextStyle(fontSize: 20),
          ),
          FlatButton(
            onPressed: () {
              showDialog(
                  context: context, //BuildContext对象
                  barrierDismissible: true,
                  builder: (context) {
                    return TiKuSelectDialog(tikuList, selectIndex, (int index) {
                      this.selectIndex = index;
                      curSubject = tikuList[index];
                      refresh();
                      getData();
                    });
                  });
            },
            child: Text(
              "【切换题库】",
              style: TextStyle(
                fontSize: 18,
                color: ColorConfig.color99,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildChartCell(String title, String unit, String content) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  content,
                  style: TextStyle(fontSize: 28),
                ),
                Text(unit),
              ],
            ),
          ),
          Text(title)
        ],
      ),
    );
  }

  _buildTiKuChart() {
    int doneQuestion = tiKuStatistic.doneQuestion;
    int rightQuestion = tiKuStatistic.rightQuestion;

    var doneRate = tiKuStatistic.totalQuestion > 0
        ? (doneQuestion * 100 / tiKuStatistic.totalQuestion).round()
        : 0;
    var rightRate = tiKuStatistic.doneQuestion > 0
        ? (rightQuestion * 100 / tiKuStatistic.doneQuestion).round()
        : 0;
    return Container(
      height: 60,
      child: Row(
        children: <Widget>[
          _buildChartCell("完成率", "%", doneRate.toString()),
          ColumnLine(
            width: 2,
          ),
          _buildChartCell("做题总数", "道", tiKuStatistic.doneQuestion.toString()),
          ColumnLine(
            width: 2,
          ),
          _buildChartCell("正确率", "%", rightRate.toString())
        ],
      ),
    );
  }

  _buildTiKuButton() {
    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          _buildSimpleButton("assets/images/xuexi.png", "错题本",
              "/tiku/wap/subject/${curSubject.id}/errors"),
          Expanded(
            child: Container(
              width: 60,
              height: 60,
              child: RaisedButton(
                child: Text(
                  "继续",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                color: ColorConfig.baseColorPrime,
                highlightColor: ColorConfig.baseColorPrime,
                onPressed: () {
                  RouteUtils.instance.tiKuKeepOn(context, tiKuStatistic);
                },
                shape: CircleBorder(),
              ),
            ),
          ),
          _buildSimpleButton("assets/images/wenda1.png", "收藏夹",
              "/tiku/wap/subject/${curSubject.id}/collects"),
        ],
      ),
    );
  }

  _buildSimpleButton(String res, String title, String url) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          RouteUtils.instance.goWebViewCheckLogin(context, url, true);
        },
        child: Column(
          children: <Widget>[
            Image.asset(res),
            Text(title),
          ],
        ),
      ),
    );
  }

  _buildTiKuType() {
    var screenWidth = MediaQuery.of(context).size.width;
    String subjectID = curSubject.id.toString();
    List<Map<String, dynamic>> data = [
      {
        "title": "章节练习",
        'subTitle': '查漏补缺',
        'isVip': false,
        'url': "/tiku/wap/subject/$subjectID/chapters",
        'img': 'assets/images/ChapterExercise.png',
      },
      {
        "title": "知识点练习",
        'subTitle': '对症下药',
        'isVip': false,
        'url': "/tiku/wap/subject/$subjectID/chapters",
        'img': 'assets/images/ChapterExercise.png',
      },
      {
        "title": "模拟卷·真题卷",
        'subTitle': '把握考试重难点',
        'isVip': false,
        'url': "/tiku/wap/subject/$subjectID/exams",
        'img': 'assets/images/zhentijuan.png',
      },
      {
        "title": "班级作业",
        'subTitle': '名师精选题目',
        'isVip': false,
        'url': "/tiku/wap/subject/$subjectID/work",
        'img': 'assets/images/classHomework.png',
      },
      {
        "title": "绝密押题卷",
        'subTitle': '考前一周开放',
        'isVip': true,
        'url': "/tiku/wap/subject/$subjectID/exams?type=3",
        'img': 'assets/images/yatijuan.png',
        "onPress": (String url) {
          if (tiKuStatistic.access == 0) {
            ToastUtils.show("暂无权限");
          } else {
            if (curSubject.isSprintOpen > 0) {
              RouteUtils.instance.goWebViewCheckLogin(context, url, true);
            } else {
              ToastUtils.show("提示：押题卷将于考前一周开放");
            }
          }
        }
      },
      {
        "title": "易错题练习",
        'subTitle': '不该丢的分不丢',
        'isVip': true,
        'url': "/tiku/wap/chapter?chapterType=4&id=$subjectID",
        'img': 'assets/images/yiCuoTi.png',
        "onPress": (String url) {
          if (tiKuStatistic.access == 0) {
            ToastUtils.show("暂无权限");
          } else {
            RouteUtils.instance.goWebViewCheckLogin(context, url, true);
          }
        }
      },
    ];

    int columnNum = 2;
    double cellHeight = 70;
    // 宽度 比 高度
    var ratio = (screenWidth / columnNum) / cellHeight;
    var round = (data.length / 2).round();

    return Container(
      height: cellHeight * round + 10,
      margin: EdgeInsets.only(bottom: 20),
      child: new GridView.count(
        //禁用滚动事件，交给上级去滚动
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: columnNum,
        padding: EdgeInsets.only(left: 10, right: 10),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: ratio,
        children: data.map((Map<String, dynamic> bean) {
          //单个的高度 ： screenWidth/2 * childAspectRatio :
          return FlatButton(
            onPressed: () {
              if (bean['onPress'] is Function) {
                var fun = bean['onPress'];
                fun(bean['url']);
              } else {
                RouteUtils.instance
                    .goWebViewCheckLogin(context, bean['url'], true);
              }
            },
            padding: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.only(left: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConfig.color60,
                borderRadius: BorderRadius.all(new Radius.circular(5)),
              ),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              bean['title'],
                              maxLines: 1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              bean['subTitle'],
                              maxLines: 1,
                              style: TextStyle(
                                  color: Color(0xFFBCD8F8), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          bean['img'],
                          scale: 0.8,
                          width: 40,
                          height: 40,
                        ),
                        margin: EdgeInsets.only(right: 5),
                      ),
                    ],
                  ),
                  _buildVip(bean['isVip'])
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  _buildVip(bool isVip) {
    if (!isVip) {
      return Container(
        width: 0,
      );
    }
    return Container(
      width: 38,
      height: 13,
      child: Image.asset(
        "assets/images/vip.png",
        fit: BoxFit.fill,
      ),
    );
  }

  //推荐
  _buildRecommend() {
    if (recommendKnows == null || recommendKnows.list.length == 0) {
      return new Container(
        child: Text("暂无推荐"),
      );
    }

    List<Widget> views = [];
    for (int i = 0; i < recommendKnows.list.length; i++) {
      KnowInfo info = recommendKnows.list[i];
      views.add(
        new Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(
                context,
                color: ColorConfig.colorEf,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    info.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: SmoothStarRating(
                  starCount: 5,
                  rating: info.importance / 2,
                  color: Colors.orange,
                  size: 10,
                  borderColor: Colors.orange,
                ),
                width: 50,
              ),
              _buildBottomBt("学习", 5, () {
                RouteUtils.instance.goWebView(
                    context,
                    Api.BASE_URL +
                        "/i/test/knows/lesson/${info.id.toString()}?isNew=1");
              }),
              _buildBottomBt("练题", 10, () {
                RouteUtils.instance.goWebView(
                    context,
                    Api.BASE_URL +
                        "/tiku/wap/chapter?chapterType=3&id=${info.id}");
              }),
            ],
          ),
        ),
      );
    }
    return Column(
      children: views,
    );
  }

  _buildBottomBt(String title, double left, Function fun) {
    return Container(
      margin: EdgeInsets.only(left: left),
      child: FlatButton(
        onPressed: fun,
        child: Text(
          title,
          style: TextStyle(
            color: ColorConfig.baseColorPrime,
          ),
        ),
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          side: BorderSide(color: ColorConfig.baseColorPrime, width: 1.6),
        ),
      ),
      width: 60,
    );
  }
}
