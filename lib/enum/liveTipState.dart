class LiveState {
  String topTip="";
  int code=0;
  String countDownTip="";
  String bottomTip="";
  String backTo="";
  String routeName="";
  bool isPreLive=false;

  LiveState(this.topTip, this.code, this.countDownTip, this.bottomTip,
      this.backTo, this.routeName, this.isPreLive);
}

class LiveTipStateEnum {
  static final liveNotStart =
      LiveState("直播尚未开始", 405, "倒计时", '先去首页看看,过一会儿再来', "返回首页", "home", false);
  static final livePreStart = LiveState("直播暂未开始", 405, "倒计时", '先去首页看看,过一会儿再来', "返回首页", "home", false);
  static final notStartNotLogin = LiveState("暂未登录", 401, "倒计时", '立即登录,观看直播', "立即登录", "login", false);
  static final startNotLogin = LiveState("暂未登录", 401, "已开始", '立即登录,观看直播', "立即登录", "login", false);
  static final notBuy = LiveState("该账号无权限", 406, "已开始", '立即购买,或者切换账号', "立即购买", "login", false);
  static final outOfService = LiveState("小呀开小差了", 407, "已开始", '小呀开小差，请再试一次', "立即刷新", "home", false);
  static final getinLive = LiveState("直播已经开始", 200, "", '直播已经开始，就等你来了', "立即进入", "live", false);
  static final noNet = LiveState("没有网络", 400, "", '链接不上服务器', "立即进入", "立即刷新", false);
}

