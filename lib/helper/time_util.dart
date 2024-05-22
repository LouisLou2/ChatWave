class TimeUtil{
  // 不包括今天
  static bool inPrevious7Days(DateTime time){
    final now = DateTime.now();
    final diff = now.difference(time);
    return diff.inDays <= 7 && diff.inDays >= 1;
  }
  static bool sameDay(DateTime time1,DateTime time2){
    return time1.year == time2.year && time1.month == time2.month && time1.day == time2.day;
  }
}