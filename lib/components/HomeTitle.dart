import 'package:flutter/material.dart';
import '../theme/Colors.dart';

class HomeTitle extends StatelessWidget {
  final String title;
  final bool showRightArrow;
  final VoidCallback click;
  final EdgeInsetsGeometry margin;
  final String rightText;

  HomeTitle(this.title, {this.showRightArrow, this.click,this.margin,this.rightText});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: this.margin==null?const EdgeInsets.only(top: 5, bottom: 10):this.margin,
        child: Row(children: <Widget>[
          Expanded(
            child: new Container(),
          ),
          Expanded(
            child: new Container(
              alignment: AlignmentDirectional.center,
              child: new Text(
                title,
                style: TextStyle(
                  color: ColorConfig.color33,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: this.showRightArrow
                ? new FlatButton(
//                    alignment: AlignmentDirectional.centerEnd,
                    onPressed: () {
                      this.click();
                    },
                    child: Row(
                      children: <Widget>[
                        new Text(
                          this.rightText==null?"更多":this.rightText,
                          style: TextStyle(fontSize: 16, color: Colors.black45),
                        ),
                        new Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black45,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ))
                : new Container(),
          ),
        ]));
  }
}
