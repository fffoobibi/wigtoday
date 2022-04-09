import 'package:intl/intl.dart';

// 金额格式化
String amountFormat(double val) {
  return NumberFormat('#,##0.00', 'en_US').format(val);
}

// 时间格式化
String timeFormat(int val, [String fmt='yyyy-MM-dd']) {
  if (val == 0) return '';
  int time = val > 9999999999 ? val : val * 1000;
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
  final int year = date.year;
  final int month = date.month;
  final int day = date.day;
  final int hour = date.hour;
  final int minute = date.minute;
  final int second = date.second;

  fmt = fmt.replaceAll('yyyy', formatNumber(year))
    .replaceAll('MM', formatNumber(month))
    .replaceAll('dd', formatNumber(day))
    .replaceAll('hh', formatNumber(hour))
    .replaceAll('mm', formatNumber(minute))
    .replaceAll('ss', formatNumber(second));

  return fmt;
}

// 显示时间阶段
String timePeriod(int val, [String fmt='yyyy-MM-dd']) {
  if (val == 0) return '';
  int time = val > 9999999999 ? val : val * 1000;
  int now = DateTime.now().millisecondsSinceEpoch;
  final double interval = (now - time) / 1000;

  // 间隔小于5分钟
  if (interval < 5 * 60) {
    return "刚刚";
  } else if (interval < 60 * 60) {
    return '${interval ~/ 60}分钟前';
  } else if (interval < 24 * 60 * 60) {
    return '${interval / 60 ~/ 60}小时前';
  } else if (interval < 3 * 24 * 60 * 60) {
    return '${interval / 24 / 60 ~/ 60}天前';
  }

  return timeFormat(val, fmt);
}

String formatNumber(int n) {
  String str = n.toString();
  return str.length < 2 ? '0$str' : str;
}