import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/model/study_course.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class StudyMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudyMenu();
  }

  final List<StudyResource> classList;

  final List<StudyResource> courseList;

  final Function onPress;

  StudyMenu(this.classList, this.courseList,this.onPress);
}

class _StudyMenu extends State<StudyMenu> {
  _buildClass(
      BuildContext context, List<StudyResource> classList, int type) {
    if (classList.length == 0) {
      return [
        Container(
          height: 0,
        )
      ];
    }

    List<Widget> list = [
      new Container(
        height: 30,
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Text(
          type==1?"系统班级":"单项课程",
          style: TextStyle(fontSize: 20),
        ),
      )
    ];

    classList.forEach((item) {
      list.add(Container(
        height: 44,
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: FlatButton(
          onPressed: () {
            widget.onPress(item,type);
          },
          color: ColorConfig.colorEf,
          child: Text(
            item.title,
            maxLines: 1,
            style: TextStyle(fontSize: 18),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> classWidget = _buildClass(context, widget.classList, 1);
    classWidget.addAll(_buildClass(context, widget.courseList, 2));
    return ListView(
      padding: EdgeInsets.only(
        top: 30,
      ),
      children: classWidget,
    );
  }
}
