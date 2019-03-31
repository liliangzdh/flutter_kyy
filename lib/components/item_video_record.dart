
import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/model/study_learnInfo.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';
class VideoRecordItem extends StatelessWidget{

  final StudyLearnInfo info;
  final Function onPress;
  VideoRecordItem({@required this.info,@required this.onPress});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: ColorConfig.colorEf,
          borderRadius: BorderRadius.all(new Radius.circular(5)),
        ),
        child: FlatButton(
            onPressed: onPress,
            highlightColor: ColorConfig.colorE5,
            padding: EdgeInsets.only(left: 0, right: 0),
            child: new Column(children: <Widget>[
              new Container(
                  child: new Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: new Stack(
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundImage: NetworkImage(info.picture),
                          radius: 30,
                        ),
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                  height: 80),
              Stack(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 5),
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      info.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorConfig.color33,
                      ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                        "已经学习${(info.learnNum * 100 / info.courseNum).floor()}%",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConfig.color66,
                        )),
                    margin: const EdgeInsets.only(top: 40),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                height: 3.0,
                child: new LinearProgressIndicator(
                  value: info.learnNum / info.courseNum,
                  backgroundColor: ColorConfig.colorEf,
                ),
              ),
            ])),
        height: 120,
        width: 240);
  }
}