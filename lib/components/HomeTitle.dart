import 'package:flutter/material.dart';
import '../theme/Colors.dart';

class HomeTitle extends StatelessWidget {
  final String title;
  final bool showRightArrow;
  final VoidCallback click;

  HomeTitle(this.title, {this.showRightArrow, this.click});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10),
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
                          "更多",
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
