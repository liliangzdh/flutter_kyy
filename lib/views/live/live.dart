import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/liveMicroSrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/components/MyAppBar.dart';
import 'package:flutterkaoyaya/components/live_segment.dart';
import 'package:flutterkaoyaya/dialog/live_filter_dialog.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/tab_title.dart';
import 'package:flutterkaoyaya/views/live/page/playBack_live.dart';
import 'package:flutterkaoyaya/views/live/page/recent_live.dart';

/// 直播 和 回放
class Live extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Live();
  }
}

class _Live extends State<Live> {
  var isPageCanChanged = true;
  PageController mPageController = PageController(initialPage: 0);
  TabController mController;

  @override
  void initState() {
    super.initState();
    mController = TabController(
      length: 2,
      vsync: ScrollableState(),
    );

    mController.addListener(() {
      //TabBar的监听
      if (mController.indexIsChanging) {
        //判断TabBar是否切换
        onPageChange(mController.index, p: mPageController);
      }
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    //刷新 LiveSegmentHead
    eventBus.fire(new TabChangeEvent(index));
    if (p != null) {
      //判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      mController.animateTo(index); //切换Tabbar
    }
  }

  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiveSegmentHead(
        function: (int index) {
          mController.animateTo(index); //
        },
        rightClick: () {
          showDialog(
              context: context, //BuildContext对象
              barrierDismissible: true,
              builder: (BuildContext context) {
                return LiveFilterSelectDialog(
                  index: selectIndex,
                  onPress: (int i, TopCate topCate) {
                    selectIndex = i;

                    int classId = 0;
                    int courseId = 0;
                    if (topCate.type == 0) {
                      //班级
                      classId = topCate.id;
                    } else if (topCate.type == 1) {
                      //课程
                      courseId = topCate.id;
                    }

                    eventBus.fire(new RefreshPlayBackEvent(classId,courseId));
                  },
                );
              });
        },
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                onPageChanged: (int index) {
                  if (isPageCanChanged) {
                    //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
                    onPageChange(index);
                  }
                },
                controller: mPageController,
                children: <Widget>[RecentLive(), PlayBackLive()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
