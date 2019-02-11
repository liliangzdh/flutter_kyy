import 'package:flutter/material.dart';

class UserCircleImage extends StatelessWidget {
  final String imgUrl;
  final EdgeInsetsGeometry margin;

  UserCircleImage({Key key, this.imgUrl, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Container(
        margin: this.margin,
        child: new CircleAvatar(backgroundImage: renderImage(), radius: 25));
  }

  renderImage() {
    if (imgUrl == null || imgUrl.length == 0) {
      return renderDefault();
    }
    return new NetworkImage(imgUrl);
  }


  renderDefault() {
    return new AssetImage("assets/images/icon_user.png");
  }
}
