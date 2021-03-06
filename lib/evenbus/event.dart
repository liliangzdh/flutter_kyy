import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class DrawerEvent {
  String text;

  DrawerEvent(this.text);
}


class VideoScrollEvent {
  VideoScrollEvent();
}


class LoginEvent{
  bool isLogin;
  LoginEvent(this.isLogin);
}

class TabChangeEvent {
  int index;
  TabChangeEvent(this.index);
}


class RefreshPlayBackEvent {
  int classId;
  int courseId;
  RefreshPlayBackEvent(this.classId,this.courseId);
}