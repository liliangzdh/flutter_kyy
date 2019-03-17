import 'package:flutter/material.dart';

class PlayBackLive extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlayBackLive();
  }
}

class _PlayBackLive extends State<PlayBackLive> with AutomaticKeepAliveClientMixin{


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
    return Container(
      color: Colors.red,
      child: Text("第二个页面 1"),
    );
  }
}
