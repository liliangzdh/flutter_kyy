import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutterkaoyaya/api/net/StudySrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
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
      aspectRatio: Utils.getScreenWidth(context) / 240,
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
              "${lessonInfo.title==null?"":lessonInfo.title}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            FlatButton(
              onPressed: () {

                study(lessonInfo.status, lessonInfo.lessonId, lessonInfo.type,
                    lessonInfo.target);
              },
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
                    lessonStudyOnPress: (LessonInfoItem lessonInfoItem) {
                  study(lessonInfoItem.status, lessonInfoItem.id,
                      lessonInfoItem.lessonType, lessonInfoItem.target);
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

    if(appResponse.code != 200){
      ToastUtils.show(appResponse.msg);
      return;
    }

    courseInfo = CourseInfo.fromJson(appResponse.result["courseInfo"]);
    List list = appResponse.result["list"];

    courseInfo.access = appResponse.result["access"];
    lessonList = list.map((m) => LessonInfoItem.fromJson(m)).toList();

    // 处理 数据 。给listView 展示出来。
    int j = 0;
    bool hasChapter = false;
    int chapterSelectIndex = 0;


    lessonList.forEach((info) {
      info.isSelect = info.id == courseInfo.lastLesson;
      if (info.type == "chapter") {
        info.chapterIndex = j;
        hasChapter = true;
        j++;
      } else {
        info.chapterIndex = j - 1;
      }
      //要展示的chapter 如果有chapter 的话
      if (hasChapter &&
          courseInfo.lastLesson != 0 &&
          (info.id == courseInfo.lastLesson)) {
        chapterSelectIndex = info.chapterIndex;
      }
    });

    lessonList.forEach((item) {
      if (!hasChapter) {
        //如果没有 chapter  这个目录，把所有的展示出来
        item.open = true;
        item.isSelect = item.id == courseInfo.lastLesson;
      } else {
        item.open = chapterSelectIndex == item.chapterIndex;
      }
    });

    if(hasChapter && lessonList[0].type != "chapter"){
      //有chapter  但是 第一个 确不是video
      for(int i=0;i<lessonList.length;i++){
        lessonList[i].open = true;
        if(lessonList[i].type == "chapter"){
          break;
        }
      }
    }

    print("-----"+lessonList[0].open.toString()+lessonList[0].title);


    if (courseInfo.lastLesson != 0) {
      print("-----上次学习的lesson ID" + courseInfo.lastLesson.toString());
      appResponse = await StudySrv.getLessonInfo(
          widget.courseID, courseInfo.lastLesson.toString());

      if (appResponse.code == 200) {
        lessonInfo = LessonInfo.fromJson(appResponse.result);
      }else{
        ToastUtils.show(appResponse.msg);
      }
      //以前读取的默认选中
    }
    setState(() {});

    //获取数据成功之后，自动滚动到自动位置
    eventBus.fire(new VideoScrollEvent());
  }


  ///点击条目 看视频或者是其他
  study(String status, int id, String type, String target) async {
    if (status == "unpublished") {
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
    String state = jumpState(type, target);

    AppResponse appResponse =
        await StudySrv.getLessonInfo(widget.courseID, id.toString());

    if (appResponse.code != 200) {
      ToastUtils.show(appResponse.msg);
      return;
    }
    print("----->" + appResponse.result.toString());
    lessonInfo = LessonInfo.fromJson(appResponse.result);
    print("======state:" + state);
    switch (state) {
      case "video":
        setState(() {
          showVideo = true;
        });
        initPlay(lessonInfo.url);
        break;
    }
  }

  String jumpState(String lessonType, String target) {
    switch (lessonType) {
      case "url":
        if (target == 'iframe') {
          return "iframe";
        }
        return "outLink";
      case "text":
        return "text";
      case "video":
        return "video";
    }
    return "";
  }
}

class TabTitle {
  String title;
  int id;

  TabTitle(this.title, this.id);
}
