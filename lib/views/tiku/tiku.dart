import 'package:flutter/material.dart';

class TiKu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TiKu();
  }
}

class _TiKu extends State<TiKu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("题库"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Text("asas"),
        ],
      ),
    );
  }
}
