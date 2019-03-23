import 'package:flutterkaoyaya/enum/liveTipState.dart';


class TimeUtils {
  static getDateDiff(String deadline) {
    DateTime now = DateTime.now();
    DateTime deadLineTime = DateTime.parse(deadline);
    Duration difference = deadLineTime.difference(now);
    return difference.inDays;
  }

  static formatTime(String timeStr) {
    DateTime date = DateTime.parse(timeStr);
    return "${date.year}.${date.month > 9 ? date.month : "0${date.month}"}.${date.day}";
  }

  static String timeStr(int i, String str) {
    if (i >= 10) {
      return "${i.toString()}" + str;
    }
    if (i > 0) {
      return "0${i.toString()}" + str;
    }
    return "00" + str;
  }

  static String getHours(String endTimeStr){
    try{
      DateTime endTime  = DateTime.parse(endTimeStr);
      return timeStr(endTime.hour, "")+":"+timeStr(endTime.minute, "");
    }catch(e){

    }
    return "";
  }

  static String format(String startTime){
    DateTime endTime  = DateTime.parse(startTime);
    return "${endTime.year}:${timeStr(endTime.month, "")}:${timeStr(endTime.day, "")}  ${timeStr(endTime.hour, "")}:${timeStr(endTime.minute, "")}";
  }

  static isLive(String start, String end) {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime.parse(start);
    DateTime endTime = DateTime.parse(end);
    if (now.isAfter(startTime)) {
      return true;
    }
    return false;
  }

  static formatSampleTime(String startTime) {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime.parse(startTime);
    Duration duration = startDate.difference(now);
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    String timeString =
        "${timeStr(hours, "小时")}${timeStr(minutes, "分")}${timeStr(seconds, "秒")}";
    return {"timeString": timeString, "duration": duration};
  }

  static formatSampleTime2(String startTime) {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime.parse(startTime);
    Duration duration = startDate.difference(now);
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    String timeString =
        "${timeStr(hours, ":")}${timeStr(minutes, ":")}${timeStr(seconds, "")}";
    return {"timeString": timeString, "duration": duration};
  }

  static LiveState judgeState(bool isLogin, String start) {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime.parse(start);
    Duration duration = startTime.difference(now);
    if (duration.inSeconds > 1800) {
      //直播未开始
      return LiveTipStateEnum.liveNotStart;
      //距离直播时间小于1小时
    } else if (duration.inSeconds > 0 && duration.inSeconds < 1800) {
      if (!isLogin) {
        return LiveTipStateEnum.notStartNotLogin;
      } else {
        return LiveTipStateEnum.livePreStart;
      }
    } else {
      //直播已经开始,如果没有登录
      if (!isLogin) {
        return LiveTipStateEnum.startNotLogin;
      } else {
        return LiveTipStateEnum.getinLive;
      }
    }
  }
}
