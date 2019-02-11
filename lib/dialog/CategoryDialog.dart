
import 'package:flutter/material.dart';
import '../views/drawer/MyDrawer.dart';
class CategoryDialog extends Dialog{

//  @override
//  Widget build(BuildContext context) {
//    return new Material( //创建透明层
//      type: MaterialType.button, //透明类型
//      child: DrawerPage(),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return DrawerPage();
  }
}