import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new SizedBox(
        width: 120,
        height: 120,
        child: new Container(
          decoration: ShapeDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(ColorConfig.baseColorPrime),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "加载...",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
