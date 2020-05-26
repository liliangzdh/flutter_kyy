import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class Loading extends StatelessWidget {


  final bool isLoading;
  String text = '加载中...';
  Loading(this.isLoading,{this.text});



  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoading();
    }
    return Container();
  }


  _buildLoading(){
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
                  text,
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
