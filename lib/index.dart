import 'package:flutter/material.dart';
import 'views/main/HomePage.dart';
import 'views/main/StudyPage.dart';
import 'views/main/UserCenterPage.dart';
import 'views/drawer/MyDrawer.dart';
import 'common/net_init.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => new _IndexState();
}

class _IndexState extends State<Index> {
  final List<Widget> childList = [];
  int _currentIndex = 0;
  PageController mPageController = PageController(initialPage: 0);

  void onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
    mPageController.jumpToPage(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    childList.add(new Home());
    childList.add(new StudyPage());
    childList.add(new UserCenterPage());
    //初始化登录操作
    netInit.initAppState();
  }

  bottomNavigationBarItem(String title, int index, IconData icon) {
    return new BottomNavigationBarItem(
      icon: new Icon(
        icon,
        color: _currentIndex == index ? Colors.blue : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex == index ? Colors.blue : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          bottomNavigationBarItem("首页", 0, Icons.home),
          bottomNavigationBarItem("学习", 1, Icons.book),
          bottomNavigationBarItem("个人", 2, Icons.person),
        ],
        currentIndex: _currentIndex,
        onTap: onTabChange,
      ),
      body: PageView(
        children: childList,
        controller: mPageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (int index) {
          setState(() {
            if (_currentIndex != index) {
              _currentIndex = index;
            }
          });
        },
      ),
      drawer: new Drawer(child: new DrawerPage()),
    );
  }
}
