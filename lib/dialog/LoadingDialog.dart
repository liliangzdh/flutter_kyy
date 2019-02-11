import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadingDialog extends Dialog {
  String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  back(BuildContext con) {
    Navigator.pop(con);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.black12,
      child: new FlatButton(
        onPressed: () {
          back(context);
        },
        child: new Material(
          type: MaterialType.transparency,
          child: new Center(
            child: new SizedBox(
              width: 120,
              height: 120,
              child: new Container(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
