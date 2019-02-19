import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutterkaoyaya/api/net/StudySrv.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/model/app_response.dart';
import 'package:video_player/video_player.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(
        'https://vod.kaoyaya.com/3ba827e5fc1e4802b15c4758c3181d68/a713c75721e847daae72bfff7f5c11df-4b6ffae84f2e1d243955ecaedcf11a3e.m3u8');
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: widget.width / 240,
      autoPlay: true,
      looping: true,
//      customControls: Center(
//        child: Container(
//          alignment: AlignmentDirectional.center,
//          child: Text("asas"),
//          color: Colors.black.withOpacity(0.5),
//          height: 50,
//          width: widget.width,
//        ),
//      ),
//      showControls: false,
    );

    initNet();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text("视频"),
//      ),
      body: new Container(
        height: 240,
        child: Chewie(
          controller: chewieController,
        ),
      ),
    );
  }

  void initNet() async {
    AppResponse appResponse = await StudySrv.getCourseInfo(92019);
    print(appResponse.result.toString());
    String id = appResponse.result["courseInfo"]["id"];
    print("--" + appResponse.result["courseInfo"].toString());
    print("--" + id.toString());
    print("--" + appResponse.result["list"].toString());
    appResponse = await StudySrv.getLessonInfo(widget.courseID, "22386");
    print(appResponse.result["url"]);
  }
}
