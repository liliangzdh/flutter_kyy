import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/model/TiKuSubject.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

// ignore: must_be_immutable
class TiKuCell extends StatelessWidget {
  List<TiKuSubject> tikuList = [];

  Function onPress;

  TiKuCell({@required this.tikuList, this.onPress});

  @override
  Widget build(BuildContext context) {
    if (tikuList.length == 0) {
      return new Container(height: 360);
    }

    var screenWidth = MediaQuery.of(context).size.width;
    var data = tikuList;
    int columnNum = 2;
    double cellHeight = 120;
    // 宽度 比 高度
    var ratio = (screenWidth / columnNum) / cellHeight;
    var round = (data.length / 2).round();

    return new Container(
      height: cellHeight * round,
      child: new GridView.count(
        //禁用滚动事件，交给上级去滚动
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: columnNum,
        padding: EdgeInsets.only(left: 10, right: 10),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: ratio,
        children: data.map((TiKuSubject bean) {
          //单个的高度 ： screenWidth/2 * childAspectRatio :
          return FlatButton(
            padding: EdgeInsets.all(0),
            child: Container(
              child: new Stack(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        height: 22,
                      ),
                      new Expanded(
                        child: new Container(
                          width: screenWidth,
                          alignment: AlignmentDirectional.center,
                          padding: EdgeInsets.only(top: 30),
                          child: new Text(
                            bean.name,
                            style: TextStyle(fontSize: 18),
                          ),
                          decoration: new BoxDecoration(
                            color: ColorConfig.colorF3,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                      )
                    ],
                  ),
                  new Container(
                      alignment: AlignmentDirectional.topCenter,
                      child: Image.asset(
                        "assets/images/tiku_write.png",
                        fit: BoxFit.fill,
                        width: 60,
                        height: 60,
                      )),
                ],
              ),
            ),
            onPressed: () async {
              if (onPress != null && onPress is Function) {
                onPress(bean.id);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
