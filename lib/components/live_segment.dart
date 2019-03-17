import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/evenbus/event.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class LiveSegmentHead extends StatefulWidget implements PreferredSizeWidget {
  final Function function;
  final Function rightClick;

  LiveSegmentHead({@required this.function, this.rightClick})
      : assert(function != null);

  @override
  Size get preferredSize {
    return new Size.fromHeight(40.0);
  }

  @override
  State createState() {
    return new _LiveSegmentHead();
  }
}

class _LiveSegmentHead extends State<LiveSegmentHead> {
  bool selectFirst = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<TabChangeEvent>().listen((TabChangeEvent event) {
      refresh(event.index);
    });
  }

  void refresh(int index) {
    bool flag = index == 0;
    if (flag != selectFirst) {
      if (this.mounted) {
        setState(() {
          selectFirst = flag;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: Utils.getStateBarHeight(context)),
      alignment: AlignmentDirectional.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
            width: 80,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Utils.getScreenWidth(context) / 2 - 80 - 90),
            child: _buildButton(),
          ),
          _buildRight(),
        ],
      ),
    );
  }

  _buildRight() {
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Container(
        width: 80,
        margin:
            EdgeInsets.only(left: Utils.getScreenWidth(context) / 2 - 90 - 80),
        child: Row(
          children: <Widget>[
            new Text(
              "筛选",
              style: new TextStyle(
                fontSize: 18,
                color: ColorConfig.baseColorPrime,
              ),
            ),
            Icon(
              Icons.filter_list,
              color: ColorConfig.baseColorPrime,
            )
          ],
        ),
      ),
      onPressed: () {
        widget.rightClick();
      },
    );
  }

  _buildButton() {
    var height = 34.0;
    return Container(
      height: height,
      width: 180,
      decoration: BoxDecoration(
        color: ColorConfig.colorF3,
        borderRadius: BorderRadius.all(Radius.circular(height / 2)),
      ),
      child: FlatButton(
        highlightColor: ColorConfig.colorF3,
        onPressed: () {
          setState(() {
//            selectFirst = !selectFirst;
            widget.function(selectFirst ? 1 : 0);
          });
        },
        padding: EdgeInsets.all(0),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              child: Text(
                "直播",
                style: TextStyle(color: ColorConfig.color66, fontSize: 20),
              ),
              width: 100,
              height: height,
            ),
            Container(
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.only(left: 80),
                child: Text(
                  "回放",
                  style: TextStyle(color: ColorConfig.color66, fontSize: 20),
                ),
                width: 100,
                height: height),
            Container(
              alignment: AlignmentDirectional.center,
              margin: EdgeInsets.only(left: selectFirst ? 0 : 80),
              child: Text(
                selectFirst ? "直播" : "回放",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              width: 100,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(height / 2))),
            ),
          ],
        ),
      ),
    );
  }
}
