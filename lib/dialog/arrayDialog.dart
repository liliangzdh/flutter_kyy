import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class ArrayListSelectDialog extends StatefulWidget {
  final List<TopCate> array;

  final Function onPress;
  final int index;

  ArrayListSelectDialog(this.array,this.index, this.onPress);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ArrayListSelectDialog();
  }
}

class _ArrayListSelectDialog extends State<ArrayListSelectDialog> {
//  @override
//  Widget build(BuildContext context) {
//    return new Material( //创建透明层
//      type: MaterialType.button, //透明类型
//      child: DrawerPage(),
//    );
//  }

//  new Column(
//  mainAxisAlignment: MainAxisAlignment.start,
//  crossAxisAlignment: CrossAxisAlignment.center,
//  children: <Widget>[
//  Container(width: Utils.getScreenWidth(context),
//  color: Colors.white,
//  child: Text("asa"),)
//  ],
//  )

  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("-----select "+widget.index.toString());
    index = widget.index;
  }

  rendList(BuildContext context) {
    List<Widget> list = [];

    list.add(new Container(
      color: Colors.white.withOpacity(0.0),
      height: 56,
    ));

    for (int i = 0; i < widget.array.length; i++) {
      list.add(new Container(
        color: Colors.white,
        child: FlatButton(
            onPressed: () {

              setState(() {
                index = i;
              });
              widget.onPress(i);

              Navigator.of(context).pop();
            },
            child: Container(
              width: Utils.getScreenWidth(context),
              alignment: AlignmentDirectional.center,
              child: Text(
                widget.array[i].name,
                style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    color: index == i
                        ? ColorConfig.baseColorPrime
                        : ColorConfig.color99),
              ),
            )),
        height: 40,
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = rendList(context);
    return GestureDetector(
      child: Container(
        child: new Container(
          color: Colors.black.withOpacity(0.0),
          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            mainAxisAlignment: MainAxisAlignment.start,
//            textBaseline:TextBaseline.alphabetic,
//            textDirection: TextDirection.rtl,
            children: list,
          ),
        ),
      ),
      onTapUp: (_) {
        Navigator.of(context).pop();
      },
    );
  }
}
