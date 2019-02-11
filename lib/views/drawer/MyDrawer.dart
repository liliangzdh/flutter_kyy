import 'package:flutter/material.dart';
import '../../model/Category.dart';
import '../../provide/single_global_instance/appstate.dart';
import '../../provide/single_global_instance/appstate_bloc.dart';
import '../../evenbus/event.dart';
import '../../store/share_preferences.dart';


class DrawerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _Drawer();
  }

  final DrawerCallback callback;

  DrawerWidget({
    Key key,

    ///add start
    this.callback,

    ///add end
  }) : super(key: key);
}

class _Drawer extends State<DrawerWidget> {
  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    Category bean = await SharePreferenceUtils.getCategory();
    if (bean == null) {
      id = -1;
    } else {
      id = bean.id;
      setState(() {
        id = id;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void change(int index, Category category) async {
    if (id == category.id) {
      return;
    }

    setState(() {
      id = category.id;
    });

    await SharePreferenceUtils.saveCategory(category.id,category.name);
    Navigator.of(context).pop();
    eventBus.fire(new DrawerEvent(""));
  }

  showListItem(List<Category> categoryList) {
    List<Widget> listWidget = [];

    if (categoryList == null) {
      return [new Container(width: 0, height: 0)];
    }

    for (int i = 0; i < categoryList.length; i++) {
      var isSelect = categoryList[i].id == this.id ? true : false;
      listWidget.add(new Container(
        margin: const EdgeInsets.only(top: 10),
        height: 40,
        child: FlatButton(
            color: isSelect ? Colors.blue : Colors.white,
            padding: EdgeInsets.only(left: 40, right: 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(80))),
            onPressed: () {
              change(i, categoryList[i]);
            },
            child: new Text(
              categoryList[i].name,
              style: TextStyle(
                  color: isSelect ? Colors.white : Colors.black38,
                  fontSize: 18),
            )),
      ));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("-------> drawer build");
    return new ListView(
      children: <Widget>[
        new Center(
            child: new Column(children: <Widget>[
          new Container(
              child: new IconButton(
                  icon: Icon(Icons.close, size: 38),
                  padding: EdgeInsets.all(1),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              margin: const EdgeInsets.only(left: 10, top: 14),
              height: 34,
              alignment: AlignmentDirectional.centerStart),
          new Divider(),
          new Text(
            "# 请君先选一个目标，祝君考运昌荣 #",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          )
        ])),
        new Container(
            margin: const EdgeInsets.only(top: 20),
            child: StreamBuilder(
              initialData: appStateBloc.value,
              stream: appStateBloc.stream,
              builder:
                  (BuildContext context, AsyncSnapshot<AppState> snapshot) {
                return new Column(
                    children: showListItem(snapshot.data.categoryList));
              },
            )),
      ],
    );
  }
}

class DrawerPage extends StatelessWidget {
  final DrawerCallback callback;

  DrawerPage({
    Key key,

    ///add start
    this.callback,

    ///add end
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new DrawerWidget(
        callback: this.callback,
      ),
      backgroundColor: Colors.white,
    );
  }
}
