import 'package:flutter/material.dart';
import '../../provide/single_global_instance/appstate.dart';
import '../../provide/single_global_instance/appstate_bloc.dart';
import '../../theme/Colors.dart';
class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Setting();
  }
}

class _Setting extends State<Setting> {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(title: new Text("设置"), centerTitle: true),
      body: new Column(
        children: <Widget>[
          new StreamBuilder(
              stream: appStateBloc.stream,
              initialData: appStateBloc.value,
              builder:
                  (BuildContext context, AsyncSnapshot<AppState> snapshot) {
                if (!snapshot.data.isLogin) {
                  return new Container(width: 0, height: 0);
                }
                return new Container(
                  color: Colors.white,
                  height: 40,
                  margin: EdgeInsets.only(top: 10),
                  child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: new FlatButton(
                          onPressed: () {
                            appStateBloc.logout();
                          },
                          child: new Text("退出登录",
                              style: TextStyle(fontSize: 18)))),
                );
              }),
        ],
      ),
      backgroundColor: ColorConfig.colorEf,
    );
  }
}
