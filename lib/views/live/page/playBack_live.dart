import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/liveMicroSrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/common/timeutils.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/components/load_more.dart';
import 'package:flutterkaoyaya/components/loading.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
import 'package:flutterkaoyaya/model/LiveBean.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class PlayBackLive extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlayBackLive();
  }
}

class _PlayBackLive extends State<PlayBackLive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<PreLiveBean> preLiveList = [];

  // listView的下拉加载
  ScrollController scrollController = ScrollController();
  bool isLoading = false; //是否正在加载数据
  int page = 0;
  int pageSize = 15;
  int sortCourse = 0;
  int sortClassroom = 0;
  bool hasMore = true;

  bool isFirstLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        //滑动到最底部了。
        print("---滑动到最底部了");
        init();
      }
    });

    eventBus.on<RefreshPlayBackEvent>().listen((RefreshPlayBackEvent event) {
      sortCourse = event.courseId;
      sortClassroom = event.classId;
      page = 0;
      init();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  init() async {
    if (isLoading) {
      print("-----正在加载");
      return;
    }
    page++;
    if (page == 1) {
      preLiveList = [];
    }
    print("---page:" + page.toString());
    AppResponse data = await LiveMicroSrv.getMyPlaybackLive(
        page, pageSize, sortCourse, sortClassroom);
    if (data.code != 200) {
      ToastUtils.show(data.msg);
      isLoading = false;
      hasMore = false;
      isFirstLoading = false;
      setState(() {

      });
      return;
    }
    List list = data.result;
    hasMore = list.length == pageSize;
    isFirstLoading = false;
    if (list.length > 0) {
      List<PreLiveBean> resList =
          list.map((m) => new PreLiveBean.fromJson(m)).toList();
      preLiveList.addAll(resList);
      setState(() {
        preLiveList = preLiveList;
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        color: Colors.white,
        child: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (index == preLiveList.length && hasMore) {
                return LoadMore();
              }
              PreLiveBean bean = preLiveList[index];
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(children: <Widget>[
                  Image.network(
                    bean.picture,
                    width: 160,
                    height: 80,
                    fit: BoxFit.fill,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: <Widget>[
                      Container(
                        width: Utils.getScreenWidth(context) - 160 - 20 - 10,
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Text(
                                "${bean.lessonTitle}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    size: 16,
                                  ),
                                  Padding(
                                    child: Text(
                                      "${bean.nickname}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                "${bean.number}播放 |${TimeUtils.format(bean.startTime)}-${TimeUtils.getHours(bean.endTime)}",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 26),
                        child: RaisedButton(
                          onPressed: () {
                            RouteUtils.instance.goLive2(
                                context,
                                1,
                                bean.startTime,
                                bean.free,
                                bean.mediaId,
                                "playback");
                          },
                          child: Text("回放"),
                          padding: EdgeInsets.all(0),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: ColorConfig.baseColorPrime, width: 1.4),
                              borderRadius:
                              BorderRadius.all(Radius.circular(4.0))),
                        ),
                        width: 60,
                        height: 28,
                      ),
                    ],
                  ),
                ]),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Divider.createBorderSide(
                      context,
                      color: ColorConfig.colorEf,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
            controller: scrollController,
            itemCount: hasMore ? preLiveList.length + 1 : preLiveList.length,
          ),
          onRefresh: _onRefresh,
        ),
      ),
      Loading(isFirstLoading)
    ],);
  }

  /// 下拉刷新方法,为list重新赋值
  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      page = 0;
      isLoading = false;
      init();
    });
  }
}
