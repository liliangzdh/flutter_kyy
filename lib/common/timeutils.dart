


class TimeUtils{



  static getDateDiff(String deadline){
    DateTime now = DateTime.now();
    DateTime deadLineTime = DateTime.parse(deadline);
    Duration difference = deadLineTime.difference(now);
    return difference.inDays;
  }

  static  formatTime(String timeStr){
    DateTime date = DateTime.parse(timeStr);
    return "${date.year}.${date.month>9?date.month:"0${date.month}"}.${date.day}";
  }

}