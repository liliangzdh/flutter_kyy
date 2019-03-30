import 'package:flutter/material.dart';
import '../theme/Colors.dart';

class ColumnLine extends StatelessWidget {

  final double width ;
  final Color color;

  final EdgeInsetsGeometry margin;


  ColumnLine({Key key, this.width=0.5,this.color= ColorConfig.colorE5,this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(width: width, color: this.color,margin: this.margin,height: double.infinity,);
  }
}
