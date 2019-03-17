import 'package:flutter/material.dart';

class RecentLive extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecentLive();
  }
}

class _RecentLive extends State<RecentLive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.blue,
      child: Text("第一个页面 0"),
    );
  }

}
