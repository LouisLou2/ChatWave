class FormatTool {

  static final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$', caseSensitive: true, multiLine: false);
  //确保字符串由字母、数字，并且总长度为8-20个字符。
  static final RegExp pwdRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,20}$',caseSensitive: true, multiLine: false);
  static final RegExp onlyNumberRegex = RegExp(r'^[0-9]+$',caseSensitive: true, multiLine: false);

  static bool isEmailValid(String email) {
    return emailRegex.hasMatch(email);
  }
  static bool isPwdValid(String password) {
    return pwdRegex.hasMatch(password);
  }

  // 将0-99的数字转换为两位字符串
  static String _twoDigit(int num) {
    assert(num >= 0 && num < 100, 'num must be in [0,100)');
    return num < 10 ? '0$num' : '$num';
  }

  /*   2024.4.5   */
  static String dateScaleStr(DateTime date){
    // 不自动补全，点分隔
    return '${date.year}.${date.month}.${date.day}';
  }
  /*   2024-05-09  */
  static String dateScaleStr2(DateTime date){
    // 不自动补全，横线分隔
    return '${date.year}-${_twoDigit(date.month)}-${_twoDigit(date.day)}';
  }
  /*    5.9    */
  static String monthDayStr(DateTime date){
    return '${date.month}.${date.day}';
  }
  /*    08:00    */
  static String hourStr(int hour){
    return '${_twoDigit(hour)}:00';
  }
  /*    5.9 08:00    */
  static String monthDayHourStr(DateTime date){
    return '${date.month}.${date.day} ${_twoDigit(date.hour)}:00';
  }

  static String transferTimeStr(DateTime time){
    return time.toIso8601String();
  }

  static String trimText(String text, {int maxLength = 25, String suffix = '...'}) {
    // 检查字符串是否超过最大长度
    if (text.length > maxLength) {
      // 如果是，则截断字符串并添加后缀
      return text.substring(0, maxLength) + suffix;
    } else {
      // 如果没有超过，就返回原字符串
      return text;
    }
  }

  static String getHistoryStr(DateTime time){
    final now = DateTime.now();
    // 如果是今天，直接今天
    if(time.year == now.year && time.month == now.month && time.day == now.day){
      return 'Today';
    }
    // 如果同一年，只显示月日
    if(time.year == now.year){
      return monthDayStr(time);
    }
    // 否则显示年月日
    return dateScaleStr(time);
  }
}