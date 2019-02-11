import 'package:flutter/material.dart';
import '../theme/Colors.dart';

class Line extends StatelessWidget {

  final double height ;
  final Color color;

  final EdgeInsetsGeometry margin;


  Line({Key key, this.height=0.5,this.color= ColorConfig.colorE5,this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(height: height, color: this.color,margin: this.margin,);
  }
}
