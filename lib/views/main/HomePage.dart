import 'package:flutter/material.dart';
import 'package:flutter_kaoyaya_plugin/flutter_kaoyaya_plugin.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/components/HomeTitle.dart';
import 'package:flutterkaoyaya/components/tiku_cell.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/model/live_info.dart';
import 'package:flutterkaoyaya/views/tiku/tiku.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../api/net/TiKuSrv.dart';
import '../../api/net/liveMicroSrv.dart';
import '../../api/net/useinfosrv.dart';
import '../../components/LiveItem.dart';
import '../../dialog/CategoryDialog.dart';
import '../../evenbus/event.dart';
import '../../model/HomeDistribute.dart';
import '../../model/HomeTopBar.dart';
import '../../model/LiveBean.dart';
import '../../model/TiKuSubject.dart';
import '../../model/app_response.dart';
import '../../store/share_preferences.dart';
import '../../theme/Colors.dart';
import '../../provide/single_global_instance/appstate_bloc.dart';
import '../../config/config.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomePage createState() {
    // TODO: implement createState
    return new HomePage();
  }
}

class HomePage extends State<Home> with AutomaticKeepAliveClientMixin {
  List<HomeDistribute> resultList = [];
  List<TiKuSubject> tikuList = [];
  List<PreLiveBean> preLiveList = [];
  List<HomeTopBar> topList = [
    HomeTopBar("精选好课", "assets/images/xuexi.png"),
    HomeTopBar("回答指南", "assets/images/wenda1.png"),
    HomeTopBar("免费试听", "assets/images/bizhi.png"),
    HomeTopBar("在线咨询", "assets/images/online.png")
  ];

  String title = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print("------home init");
    this._onRefresh();
    //只监听DrawerEvent。
    eventBus.on<DrawerEvent>().listen((DrawerEvent event) {
      this._onRefresh(isDrawer: true);
    });
  }

  Future<bool> getUserDistribute(int id) async {
    AppResponse data = await UserInfoSrv.getUserDistribute(id);
    if (data.code == 200) {
      List list = data.result;
      resultList = list.map((m) => new HomeDistribute.fromJson(m)).toList();
      if (mounted) {
        setState(() {
          resultList = resultList;
          title = title;
        });
      }
    }
    return new Future.value(true);
  }

  getTiKuNet(int id) async {
    AppResponse res = await TiKuSrv.getDistributeSubject(id);
    if (res.code == 200) {
      Map<String, dynamic> map = res.result[0];
      if (map.containsKey("id")) {
        int id = map['id'];
        res = await TiKuSrv.getSubjects(id);
        if (res.code == 200) {
          map = res.result;
          List list = map['subjects'];
          tikuList = list.map((m) => TiKuSubject.fromJson(m)).toList();
          if (mounted) {
            setState(() {
              tikuList = tikuList;
              title = title;
            });
          }
        }
      }
    }
    return new Future.value(true);
  }

  //获取全网7天内的直播消息
  getHomeLivePreLive() async {
    AppResponse response = await LiveMicroSrv.homeLivePreLive();
    if (response.code == 200) {
      List list = response.result;
      preLiveList = list.map((m) => new PreLiveBean.fromJson(m)).toList();
      if (mounted) {
        setState(() {
          preLiveList = preLiveList;
          title = title;
        });
      }
    }
    return new Future.value(true);
  }

  ///暂时录播图
  showSwipe() {
    if (resultList.length == 0) {
      return new Container(width: 100, height: 120);
    }
    var picList = resultList[0].resource;
    return new Container(
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            picList[index].pictureURL,
            fit: BoxFit.fill,
          );
        },
        itemCount: picList.length,
        autoplay: true,
        pagination: new SwiperPagination(
            builder: new DotSwiperPaginationBuilder(
                color: Colors.white, activeColor: Colors.red)),
        onTap: (int index) {
          goWebView(picList[index].resourceURL);
        },
      ),
      height: 140,
    );
  }

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  goWebView(String resourceURL) async {
    RouteUtils.instance.goWebView(context, resourceURL);
  }

  ///精品体验课

  ///展示顶部4个按钮
  showTop() {
    List<Widget> list = [];
    for (int i = 0; i < topList.length; i++) {
      var bean = topList[i];
      var view = new Expanded(
          child: new GestureDetector(
        onTapUp: (_) {
          switch (i) {
            case 0:
              String url = "${Api.BASE_URL}/i/goodsStore}";
              goWebView(url);
              break;
            case 1:
              break;
            case 2:
              String url = Api.BASE_URL + '/i/home/list/1';
              goWebView(url);
              break;
            case 3:
              break;
          }
        },
        child: Container(
            child: new Column(children: <Widget>[
          new Container(
            width: 80,
            child: new Image.asset(
              bean.imageRul,
              width: 55,
              height: 55,
            ),
          ),
          new Container(
            child: new Text(
              bean.name,
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          )
        ])),
      ));
      list.add(view);
    }
    return (new Container(
        height: 80,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: new Row(
          children: list,
        )));
  }

  renderGood() {
    if (resultList.length == 0) {
      return new Container();
    }

    var goodData = resultList[2].resource;
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
                  onPressed: () {
                    goWebView(goodData[index].resourceURL);
                  },
                  highlightColor: ColorConfig.colorE5,
                  child: new Column(children: <Widget>[
                    new Container(
                        child: new Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: new Stack(
                            children: <Widget>[
                              new CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    goodData[index].pictureURL,
                                  ),
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
                        child: Text(goodData[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConfig.color33,
                            ))),
                    new Container(
                      child: Text(goodData[index].remark,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConfig.color66,
                          )),
                      margin: const EdgeInsets.only(top: 5),
                    )
                  ])),
              height: 120,
              width: 240);
        });
  }

  renderLine() {
    return new Container(
      height: 8,
      color: ColorConfig.colorEf,
    );
  }

  ///名师推荐
  renderGoodTeacher() {
    if (resultList.length == 0) {
      return new Container(height: 360);
    }

    var screenWidth = MediaQuery.of(context).size.width;
    List<Distribute> teachList = resultList[1].resource;
    var data = teachList;
    int columnNum = 2;
    double cellHeight = 180;
    // 宽度 比 高度
    var ratio = (screenWidth / columnNum) / cellHeight;
    var round = (data.length / 2).round();

    return new Container(
      height: cellHeight * round,
      child: new GridView.count(
        //禁用滚动事件，交给上级去滚动
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: columnNum,
        padding: EdgeInsets.only(left: 5, right: 10),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: ratio,

        children: data.map((Distribute bean) {
          //单个的高度 ： screenWidth/2 * childAspectRatio :
          return FlatButton(
              onPressed: () {
                goWebView(bean.resourceURL);
              },
              padding: EdgeInsets.all(0),
              child: new Container(
                padding: EdgeInsets.only(left: 5),
                child: new Column(
                  children: <Widget>[
                    new Image.network(
                      bean.pictureURL,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 100,
                    ),
                    new Container(
                      child: new Text(
                        bean.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      margin: EdgeInsets.only(top: 10),
                      alignment: AlignmentDirectional.centerStart,
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 4),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            alignment: AlignmentDirectional.centerStart,
                            child: SmoothStarRating(
                              starCount: 5,
                              rating: 5,
                              color: Colors.orange,
                              size: 15,
                              borderColor: Colors.orange,
                            ),
                            width: 80,
                          ),
                          new Expanded(
                              child: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            child: new Text(
                              bean.remark.trim(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black12,
                              ),
                            ),
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        }).toList(),
      ),
    );
  }

  ///智能题库
  renderTiku() {
    return TiKuCell(
      tikuList: this.tikuList,
      onPress: (int subjectID) async {
        //跳转到题库
        Category category = await SharePreferenceUtils.getCategory();
        RouteUtils.instance.go(
          context,
          TiKu(
            examType: category.id,
            subjectID: subjectID,
          ),
        );
      },
    );
  }

  ///直播列表
  renderLive() {
    if (preLiveList == null || preLiveList.length == 0) {
      return new Container(
        height: 200,
      );
    }
    return new Column(
      children: preLiveList.map((PreLiveBean bean) {
        return new LiveItem(bean, this.goLive);
      }).toList(),
    );
  }

  void goLive(PreLiveBean bean) {
    RouteUtils.instance.goLive2(
        context, bean.access, bean.startTime, bean.free, bean.mediaId, "live");
  }

  ///刷新
  Future<Null> _onRefresh({isDrawer: false}) async {
    Category bean = await SharePreferenceUtils.getCategory();
    if (bean == null) {
      //如何全面屏dialog
      showDialog(
          context: context, //BuildContext对象
          barrierDismissible: true,
          builder: (BuildContext context) {
            return new CategoryDialog();
          });
    } else {
      title = bean.name;
      print("--------name:>" + bean.name);
      await getUserDistribute(bean.id);
      await getTiKuNet(bean.id);
      await getHomeLivePreLive();
      print("-----------on refresh end");
    }
  }

  ///来之 drawer 刷新
  drawerRefresh() {
    print("--------------drawer init ");
  }

  goActivity() {
    FlutterKaoyayaPlugin.live({
      "accessToken":
          "yEzMxMzM2UWMyEWYwM2YxAjZkJTOjJWOxYWN4QjYkZDf8xXfiQzMzQjMy8FN0MTM2UjI6ISZtFmbyJCLwojIhJCLiAjI6ICZpdmIs01W6Iic0RXYiwCOzkDM0MTM1UTM6ISZtlGdnVmciwiI0ITNyMTO1UjI6ICZphnIsUzMzETM6ICZpBnIsISVTx0bwlmYs10QQZDOqBlI6IyclR2bjJCL0MzM0IjM6ICZp9VZzJXdvNmIsIiI6IichRXY2FmIsAjOiIXZk5WZnJCL4MzNxUzMxUTNxojIlJXawhXZiwCN0MTM2UjOiQWat92byJCLiATNiVTdcBTNiVTdchjM3YTdcJiOiUWbh52ajlmbiwiIyV2c1JiOiUGbvJnIsICN1AzNyETMiojIklWdiwSNzMTMxojIkl2XyVmb0JXYwJye",
      "title": "这是一个标题",
      "playbackId": 1495.toString(),
      "type": "nolive" //live
    });
  }

  @override
  Widget build(BuildContext context) {
    // 猛一看效果出来了，左右切换界面没有问题，结果跳转新界面时又出现新问题，
    // 当第一页跳转新的界面再返回，再切第二、三页发现重置了，再切回第一页发现页被重置了。
    //发生这种情况需要在重写Widget build(BuildContext context)时调用下父类
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text(title),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new Container(
            padding: const EdgeInsets.only(right: 10),
            child: new Center(
              child: new Text(
                "咨询",
                style: new TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
        leading: IconButton(
            icon: Icon(
              Icons.dehaze,
              color: Colors.black,
              size: 26,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: RefreshIndicator(
          child: ListView(
            children: <Widget>[
              new Container(
                child: new Column(
                  children: <Widget>[
                    showSwipe(),
                    showTop(),

                    renderLine(),
                    //精品体验课
                    new HomeTitle("精品体验课", showRightArrow: true, click: () {
                      print("------------121212>");
                    }),

                    new Container(
                      child: new Center(child: renderGood()),
                      height: 140,
                      margin: EdgeInsets.only(bottom: 10),
                    ),

                    renderLine(),
                    //智能题库

                    new HomeTitle("智能题库", showRightArrow: false),

                    new Container(
                      child: new Text(
                        "选择题库去刷题",
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                    renderTiku(),
                    renderLine(),
                    //名师推荐
                    new HomeTitle("名师推荐", showRightArrow: true, click: () {}),
                    //名师直播
                    renderGoodTeacher(),
                    renderLine(),
                    //名师直播
                    new HomeTitle("名师直播", showRightArrow: false),
                    renderLive(),
                  ],
                ),
              )
            ],
          ),
          onRefresh: _onRefresh),
      backgroundColor: Colors.white,
    );
  }
}
