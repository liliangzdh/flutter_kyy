import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutterkaoyaya/api/net/StudySrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:flutterkaoyaya/model/course_info.dart';
import 'package:flutterkaoyaya/model/lesson_info.dart';
import 'package:flutterkaoyaya/views/study/page/NormalCourseComment.dart';
import 'package:flutterkaoyaya/views/study/page/NormalCourseList.dart';
import 'package:video_player/video_player.dart';
import '../../theme/Colors.dart';

import '../../provide/single_global_instance/appstate_bloc.dart';

class NormalCourse extends StatefulWidget {
  final int courseID;
  final double width;

  NormalCourse(this.courseID, this.width);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _NormalCourse();
  }
}

class _NormalCourse extends State<NormalCourse> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  Chewie playerWidget;
  PageController mPageController = PageController(initialPage: 0);
  List<LessonInfoItem> lessonList = [];
  CourseInfo courseInfo = new CourseInfo();

  LessonInfo lessonInfo; //当前学习的lesson;

  bool showVideo = false; //是否是播放视频

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNet();
    initTabData();
    mController = TabController(
      length: tabList.length,
      vsync: ScrollableState(),
    );

    mController.addListener(() {
      //TabBar的监听
      if (mController.indexIsChanging) {
        //判断TabBar是否切换
        print(mController.index);
        onPageChange(mController.index, p: mPageController);
      }
    });
  }

  initPlay(String videoUrl) {
    videoPlayerController?.pause();
//    videoPlayerController?.dispose();
    chewieController?.dispose();

    videoPlayerController = VideoPlayerController.network(videoUrl);
    chewieController = ChewieController(
      aspectRatio: Utils.getScreenWidth(context)/240,
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      iosUiType: UiType.MaterialUI,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.redAccent,
        handleColor: Colors.redAccent,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );

    videoPlayerController.initialize().then((value) {
      //刷新页面显示播放器，
      setState(() {});

      videoPlayerController.seekTo(Duration(seconds: 0));
      videoPlayerController.play();
    });

    videoPlayerController.addListener(() {
      print("======_");
    });
  }

  var currentPage = 0;
  var isPageCanChanged = true;

  onPageChange(int index, {PageController p, TabController t}) async {
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

  TabController mController;
  List<TabTitle> tabList;

  initTabData() {
    tabList = [
      new TabTitle('课程目录', 0),
      new TabTitle('课程评论', 1),
    ];
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    mController?.dispose();
    super.dispose();
  }

  _buildVideo() {
    if (courseInfo.picture == null) {
      return Container(
        height: 240,
      );
    }

    if (showVideo) {
      return new Container(
        height: 240,
        child: Chewie(
          controller: chewieController,
        ),
      );
    }

    return Container(
        height: 240,
        child: Stack(
          children: <Widget>[
            Image.network(
              courseInfo.picture,
              width: widget.width,
              height: 240,
              fit: BoxFit.fill,
            ),
            _buildStartStudy(),
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.black87,
                  highlightColor: Colors.black87,
                  shape: CircleBorder(),
                  padding: EdgeInsets.only(right: 0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              width: 40,
              height: 40,
              margin: EdgeInsets.only(
                  top: Utils.getStateBarHeight(context), left: 10),
            ),
          ],
        ));
  }

  _buildStartStudy() {
    if (lessonInfo != null) {
      return Container(
        alignment: AlignmentDirectional.center,
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "最近学习:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              "${lessonInfo.title}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            FlatButton(
              onPressed: () {},
              child: Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                child: Text(
                  "继续学习",
                  style: TextStyle(color: Color(0xFF23b0ff)),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.transparent,
                    border: Border.all(
                        color: ColorConfig.baseColorPrime, width: 1)),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildVideo(),
          Container(
            color: new Color(0xfff4f5f6),
            height: 38.0,
            child: TabBar(
              isScrollable: false,
              controller: mController,
              labelColor: ColorConfig.baseColorPrime,
              unselectedLabelColor: Color(0xff666666),
              indicatorWeight: 3,
              labelStyle: TextStyle(fontSize: 16.0),
              tabs: tabList.map((item) {
                return Tab(
                  text: item.title,
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (int index) {
                if (isPageCanChanged) {
                  //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
                  onPageChange(index);
                }
              },
              controller: mPageController,
              children: <Widget>[
                NormalCourseList(lessonList, courseInfo,
                    lessonStudyOnPress: (LessonInfoItem lessonInfo) {
                  print("----->" + lessonInfo.title);
                  print("----->" + lessonInfo.status);
                  study(lessonInfo);
                }),
                NormalCourseComment(),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  void initNet() async {
    AppResponse appResponse = await StudySrv.getCourseInfo(widget.courseID);
    print(appResponse.result.toString());
    courseInfo = CourseInfo.fromJson(appResponse.result["courseInfo"]);
    List list = appResponse.result["list"];

    courseInfo.access = appResponse.result["access"];
    lessonList = list.map((m) => LessonInfoItem.fromJson(m)).toList();
//    print("--" + appResponse.result["courseInfo"].toString());

    // 处理 数据 。给listView 展示出来。
    int j = 0;
    bool hasChapter = false;
    for (int i = 0; i < lessonList.length; i++) {
      LessonInfoItem info = lessonList[i];
      if (info.type == "chapter") {
        info.chapterIndex = j;
        hasChapter = true;
        j++;
      } else {
        info.chapterIndex = j - 1;
      }
    }

    //如果没有 chapter  这个目录，把所有的展示出来
    if (!hasChapter) {
      lessonList.forEach((item) {
        item.open = true;
      });
    }

    if (courseInfo.lastLesson != 0) {
      print("-----上次学习的lesson ID" + courseInfo.lastLesson.toString());
      appResponse = await StudySrv.getLessonInfo(
          widget.courseID, courseInfo.lastLesson.toString());

      if (appResponse.code == 200) {
        print("----->" + appResponse.result.toString());
        lessonInfo = LessonInfo.fromJson(appResponse.result);
        print("---->" + lessonInfo.toString());
        print("----" + lessonInfo.type);
      }
    }
    setState(() {});
  }

  //点击条目 看视频或者是其他
  study(LessonInfoItem lessonInfoItem) async {
    if (lessonInfoItem.status == "unpublished") {
      ToastUtils.show("提示：该课时内容暂未发布,敬请期待！");
      return;
    }

    if (courseInfo.access == 0 && lessonInfo.free != 1) {
      if (!appStateBloc.value.isLogin) {
        ToastUtils.show('提示：您还未购买该产品,购买后即可使用~');
      } else {
        RouteUtils.instance.goLogin(context);
      }
      return;
    }
    String state = jumpState(lessonInfoItem);

    AppResponse appResponse =
        await StudySrv.getLessonInfo(widget.courseID, "${lessonInfoItem.id}");

    if (appResponse.code != 200) {
      ToastUtils.show(appResponse.msg);
      return;
    }
    print("----->" + appResponse.result.toString());
    lessonInfo = LessonInfo.fromJson(appResponse.result);
    switch (state) {
      case "video":
        setState(() {
          showVideo = true;
        });
        initPlay(lessonInfo.url);
        break;
    }
  }

  String jumpState(LessonInfoItem lesson) {
    switch (lesson.lessonType) {
      case "url":
        if (lesson.target == 'iframe') {
          return "iframe";
        }
        return "outLink";
      case "text":
        return "text";
      case "video":
        return "video";
    }
  }
}

class TabTitle {
  String title;
  int id;

  TabTitle(this.title, this.id);
}
