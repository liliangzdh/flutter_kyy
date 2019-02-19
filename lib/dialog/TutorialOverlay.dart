import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutterkaoyaya/theme/Colors.dart';

class TutorialOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }



  rendList(BuildContext context){

    return new Container(
      color: Colors.white,
      width: Utils.getScreenWidth(context),
      alignment: AlignmentDirectional.center,
      child: new Text(
        "asas",
        style: TextStyle(
          fontSize: 18,
          decoration: TextDecoration.none,
          color: ColorConfig.color66,
        ),
      ),
      height: 30,
    );

  }


  Widget _buildOverlayContent(BuildContext context) {
//    return Center(
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Text(
//            'This is a nice overlay',
//            style: TextStyle(color: Colors.white, fontSize: 30.0),
//          ),
//          RaisedButton(
//            onPressed: () => Navigator.pop(context),
//            child: Text('Dismiss'),
//          )
//        ],
//      ),
//    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          new Container(
//            height: Utils.getStateBarHeight(context),
//            color: Colors.white,
//          ),
          new Container(
            height: 56,
            color: Colors.white.withOpacity(0.0),
          ),


          rendList(context),



        ],
      ),
      color: Colors.black12.withOpacity(0.0),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
