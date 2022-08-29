import 'package:intl/intl.dart';

class DateUtil {
  static final DateUtil instance = DateUtil.init();
  static DateFormat? timeFormatServer;
  static DateFormat? timeFormatDisplay;
  static DateFormat? dateFormatServer;
  static DateFormat? dateFormatDisplay;
  static DateFormat? datetimeFormatServer;
  static DateFormat? datetimeFormatDisplay;
  static DateFormat? datetimeUTCServer;
  static DateFormat? dayFormatDisplay;
  static DateFormat? dayFullFormatDisplay;
  static DateFormat? monthFormatDisplay;


  factory DateUtil() {
    return instance;
  }

  DateUtil.init() {
    timeFormatServer ??= DateFormat('HH:mm:ss');

    timeFormatDisplay ??= DateFormat('hh:mm aa');

    dateFormatServer ??= DateFormat('yyyy-MM-dd');

    dateFormatDisplay ??= DateFormat('dd MMM yyyy');

    datetimeFormatServer ??= DateFormat('yyyy-MM-dd HH:mm:ss');

    datetimeFormatDisplay ??= DateFormat('dd MMM yyyy, h:mm aa');

    datetimeUTCServer ??= DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    dayFormatDisplay ??= DateFormat('EEE');

    dayFullFormatDisplay ??= DateFormat('EEEE');

    monthFormatDisplay ??= DateFormat('MMM');
  }

  DateFormat getTimeFormatServer(){
    return timeFormatServer!;
  }

  DateFormat getTimeFormatDisplay(){
    return timeFormatDisplay!;
  }

  DateFormat getDateFormatServer(){
    return dateFormatServer!;
  }

  DateFormat getDateFormatDisplay(){
    return dateFormatDisplay!;
  }

  DateFormat getDatetimeFormatServer(){
    return datetimeFormatServer!;
  }

  DateFormat getDatetimeFormatDisplay(){
    return datetimeFormatDisplay!;
  }

  DateFormat getDatetimeUTCServer(){
    return datetimeUTCServer!;
  }

  DateFormat getDayFormatDisplay(){
    return dayFormatDisplay!;
  }

  DateFormat getDayFullFormatDisplay(){
    return dayFullFormatDisplay!;
  }

  DateFormat getMonthFormatDisplay(){
    return monthFormatDisplay!;
  }

}