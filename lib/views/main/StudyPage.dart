import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/components/MyAppBar.dart';
import '../../theme/Colors.dart';

class StudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MAppBar(
        child: Container(
          color: ColorConfig.baseColorPrime,
          padding: EdgeInsets.only(top: Utils.getStateBarHeight(context)),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.dehaze,
                      color: Colors.white,
                      size: 24,
                    ),
                    Container(
                      child: Text(
                        "切换",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 2, bottom: 2),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 80),
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    "初级通关班",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
