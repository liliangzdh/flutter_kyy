import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/components/Line.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
import 'package:flutterkaoyaya/model/course_info.dart';
import 'package:flutterkaoyaya/model/lesson_info.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class NormalCourseList extends StatefulWidget {
  final List<LessonInfoItem> lessonList;
  final CourseInfo courseInfo;

  final Function lessonStudyOnPress;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _NormalCourseList();
  }

  NormalCourseList(this.lessonList, this.courseInfo, {this.lessonStudyOnPress});
}

class _NormalCourseList extends State<NormalCourseList>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;

  Timer timer;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    countdown();
    eventBus.on<VideoScrollEvent>().listen((VideoScrollEvent event) {
      countdown();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void countdown()  {
    timer = new Timer(new Duration(seconds: 1), () {
      // 只在倒计时结束时回调
      if (mounted) {
        double offset = 180;

        LessonInfoItem info;
        for (int i = 0; i < widget.lessonList.length; i++) {
          if (widget.lessonList[i].isSelect) {
            info = widget.lessonList[i];
            break;
          }
        }

        if (info != null) {
          for (int i = 0; i < widget.lessonList.length; i++) {
            if (widget.lessonList[i].type != "chapter" &&
                widget.lessonList[i].open
            ) {
              offset += 40;

              if (info.id == widget.lessonList[i].id) {
                break;
              }
            } else if (widget.lessonList[i].type == "chapter") {
              offset += 50;
            }
          }
          print("-----offset:"+offset.toString());
          _scrollController.animateTo(offset-14 ,
              duration: new Duration(milliseconds: 500), curve: Curves.ease);
        }
      }
    });
  }

  _buildHeader(CourseInfo courseInfo) {
    int lessonNum = 0;
    for (int i = 0; i < widget.lessonList.length; i++) {
      if (widget.lessonList[i].lessonType == "video") {
        lessonNum++;
      }
    }
    return Container(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            courseInfo.title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Padding(
            child: Text("$lessonNum个课时 . ${courseInfo.studentNum}人学过"),
            padding: EdgeInsets.only(top: 10),
          ),
          new Container(
            height: 50,
            padding: EdgeInsets.only(right: 10),
            child: Row(
              children: <Widget>[
                Icon(Icons.message),
                Padding(
                    padding: EdgeInsets.only(left: 2, bottom: 4),
                    child: Text(
                      "2122个评论",
                      style: TextStyle(fontSize: 16),
                    )),
                Expanded(child: Container()),
                Icon(Icons.screen_share),
                Padding(padding: EdgeInsets.only(left: 2), child: Text("分享")),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.file_download)),
                Text("下载"),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.assignment)),
                Padding(padding: EdgeInsets.only(left: 2), child: Text("咨询")),
              ],
            ),
          ),
          Line(
            height: 10,
          ),
          Container(
            height: 56,
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "课时目录",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Line(
            height: 1,
          )
        ],
      ),
    );
  }

  ///chapter 类型
  _buildChapter(LessonInfoItem lessonInfo) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 49,
            child: FlatButton(
                onPressed: () {
                  List list = widget.lessonList;
                  for (int i = 0; i < list.length; i++) {
                    LessonInfoItem bean = list[i];
                    if (bean.chapterIndex == lessonInfo.chapterIndex) {
                      bean.open = !bean.open;
                    }
                  }
                  setState(() {});
                },
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          lessonInfo.title,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      lessonInfo.open
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 28,
                    ),
                  ],
                )),
          ),
          Line(
            height: 1,
          ),
        ],
      ),
    );
  }

  _buildLesson(LessonInfoItem lessonInfo) {
    return Container(
      height: lessonInfo.open ? 40 : 0,
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 39,
            alignment: AlignmentDirectional.center,
            child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  for (int j = 0; j < widget.lessonList.length; j++) {
                    widget.lessonList[j].isSelect =
                        widget.lessonList[j].id == lessonInfo.id;
                  }
                  setState(() {});
                  if (widget.lessonStudyOnPress != null) {
                    widget.lessonStudyOnPress(lessonInfo);
                  }
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 26,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          lessonInfo.lessonType == "video" ? "视频" : "图片",
                          style: TextStyle(
                              fontSize: 10,
                              color: lessonInfo.isSelect
                                  ? ColorConfig.baseColorPrime
                                  : Colors.black87),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: lessonInfo.isSelect
                                  ? ColorConfig.baseColorPrime
                                  : Colors.black,
                              width: 1),
                        ),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                          child: Container(
                        child: Text(
                          lessonInfo.title,
                          maxLines: 1,
                          style: TextStyle(
                              color: lessonInfo.isSelect
                                  ? ColorConfig.baseColorPrime
                                  : Colors.black87),
                        ),
                      )),
                      lessonInfo.free == 1
                          ? Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                "免费",
                                style: TextStyle(
                                  color: ColorConfig.baseColorPrime,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )),
          ),
          Line(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: widget.lessonList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader(widget.courseInfo);
          }
          LessonInfoItem lessonInfo = widget.lessonList[index - 1];
          if (lessonInfo.type == "chapter") {
            return _buildChapter(lessonInfo);
          }
          return _buildLesson(lessonInfo);
        },
      ),
    );
  }

  formatLessonList(List<LessonInfoItem> list) {}

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
