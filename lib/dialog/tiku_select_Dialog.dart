import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/model/Category.dart';
import 'package:flutterkaoyaya/model/TiKuSubject.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class TiKuSelectDialog extends StatefulWidget {
  final List<TiKuSubject> array;

  final Function onPress;
  final int index;

  TiKuSelectDialog(this.array, this.index, this.onPress);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TiKuSelectDialog();
  }
}

class _TiKuSelectDialog extends State<TiKuSelectDialog> {
  int index = 0;
  List<TiKuSubject> array=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    array = widget.array;
  }

  rendList(BuildContext context) {
    List<Widget> list = [];

    for (int i = 0; i < array.length; i++) {
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
                array[i].name,
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
      child: Center(
        child: SizedBox(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: list,
            ),
          ),
          height: list.length * 40.0 + 16,
        ),
      ),
      onTapUp: (_) {
        Navigator.of(context).pop();
      },
    );
  }
}
