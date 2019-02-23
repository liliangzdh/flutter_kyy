import 'package:flutter/material.dart';

class NormalCourseComment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NormalCourseComment();
  }
}

class _NormalCourseComment extends State<NormalCourseComment> with AutomaticKeepAliveClientMixin {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("_NormalCourseComment-------init");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container(
        color: Colors.redAccent,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
