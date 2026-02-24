/// Core implementation of Imperial Persian date.
library;

import 'date_constants.dart';
import 'imperial_persian_formatter.dart';

/// Represents a date in the Imperial Persian (Shahanshahi) calendar.
///
/// The Imperial Persian calendar uses the same solar calendar structure as
/// the Shamsi calendar but with epoch at the coronation of Cyrus the Great (559 BCE).
///
/// Conversion formula: Imperial Year = Shamsi Year + 1180
///
/// Example:
/// ```dart
/// final date = ImperialPersianDate(2584, 12, 5);
/// print(date.format('YYYY/MM/DD')); // 2584/12/05
/// ```
class ImperialPersianDate implements Comparable<ImperialPersianDate> {
  /// Imperial Persian year (e.g., 2604)
  final int year;

  /// Month (1-12)
  final int month;

  /// Day of month (1-31)
  final int day;

  /// Hour (0-23)
  final int hour;

  /// Minute (0-59)
  final int minute;

  /// Second (0-59)
  final int second;

  /// Millisecond (0-999)
  final int millisecond;

  /// Offset between Imperial and Shamsi calendars
  static const int imperialOffset = 1180;

  /// Creates an Imperial Persian date.
  ///
  /// Throws [ArgumentError] if the date is invalid.
  ImperialPersianDate(
    this.year,
    this.month,
    this.day, {
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
    this.millisecond = 0,
  }) {
    if (!_isValidDate(year, month, day)) {
      throw ArgumentError('Invalid Imperial Persian date: $year/$month/$day');
    }
    if (hour < 0 || hour > 23) {
      throw ArgumentError('Invalid hour: $hour');
    }
    if (minute < 0 || minute > 59) {
      throw ArgumentError('Invalid minute: $minute');
    }
    if (second < 0 || second > 59) {
      throw ArgumentError('Invalid second: $second');
    }
    if (millisecond < 0 || millisecond > 999) {
      throw ArgumentError('Invalid millisecond: $millisecond');
    }
  }

  /// Creates an Imperial Persian date from the current date and time.
  factory ImperialPersianDate.now() {
    final now = DateTime.now();
    return ImperialPersianDate.fromGregorian(now);
  }

  /// Creates an Imperial Persian date from a Gregorian [DateTime].
  factory ImperialPersianDate.fromGregorian(DateTime dateTime) {
    final shamsi = _gregorianToShamsi(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
    return ImperialPersianDate(
      shamsi[0] + imperialOffset,
      shamsi[1],
      shamsi[2],
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
      millisecond: dateTime.millisecond,
    );
  }

  /// Creates an Imperial Persian date from Shamsi (Solar Hijri) date.
  ///
  /// Example:
  /// ```dart
  /// final date = ImperialPersianDate.fromShamsi(1404, 12, 5);
  /// print(date.year); // 2584
  /// ```
  factory ImperialPersianDate.fromShamsi(
    int shamsiYear,
    int shamsiMonth,
    int shamsiDay, {
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  }) {
    return ImperialPersianDate(
      shamsiYear + imperialOffset,
      shamsiMonth,
      shamsiDay,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
    );
  }

  /// Creates an Imperial Persian date from Julian Day Number.
  factory ImperialPersianDate.fromJulianDayNumber(
    int julianDayNumber, {
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  }) {
    final greg = _julianDayNumberToGregorian(julianDayNumber);
    final shamsi = _gregorianToShamsi(greg[0], greg[1], greg[2]);
    return ImperialPersianDate(
      shamsi[0] + imperialOffset,
      shamsi[1],
      shamsi[2],
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
    );
  }

  /// Converts this Imperial Persian date to Gregorian [DateTime].
  DateTime toGregorian() {
    final shamsiYear = year - imperialOffset;
    final greg = _shamsiToGregorian(shamsiYear, month, day);
    return DateTime(
      greg[0],
      greg[1],
      greg[2],
      hour,
      minute,
      second,
      millisecond,
    );
  }

  /// Converts this Imperial Persian date to Shamsi (Solar Hijri) date.
  ///
  /// Returns a list [year, month, day].
  List<int> toShamsi() {
    return [year - imperialOffset, month, day];
  }

  /// Converts this date to Julian Day Number.
  int toJulianDayNumber() {
    final shamsiYear = year - imperialOffset;
    final greg = _shamsiToGregorian(shamsiYear, month, day);
    return _gregorianToJulianDayNumber(greg[0], greg[1], greg[2]);
  }

  /// Returns the weekday (0 = Saturday, 6 = Friday).
  int get weekDay {
    final jdn = toJulianDayNumber();
    return (jdn + 2) % 7;
  }

  /// Returns the Persian weekday name in Farsi.
  String get weekDayName => persianWeekDayNames[weekDay];

  /// Returns the Persian weekday name in English.
  String get weekDayNameEn => persianWeekDayNamesEn[weekDay];

  /// Returns the Persian month name in Farsi.
  String get monthName => persianMonthNames[month - 1];

  /// Returns the Persian month name in English.
  String get monthNameEn => persianMonthNamesEn[month - 1];

  /// Returns the number of days in the current month.
  int get monthLength {
    if (month == 12) {
      return isLeapYear() ? 30 : 29;
    }
    return month <= 6 ? 31 : 30;
  }

  /// Checks if the current year is a leap year.
  ///
  /// Uses the 33-year cycle algorithm for Persian calendar.
  bool isLeapYear() {
    final shamsiYear = year - imperialOffset;
    return _isLeapShamsiYear(shamsiYear);
  }

  /// Returns a new date with the specified fields replaced.
  ImperialPersianDate copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
  }) {
    return ImperialPersianDate(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
      millisecond: millisecond ?? this.millisecond,
    );
  }

  /// Adds the specified number of years.
  ImperialPersianDate addYears(int years) {
    return copyWith(year: year + years);
  }

  /// Adds the specified number of months.
  ImperialPersianDate addMonths(int months) {
    int newYear = year;
    int newMonth = month + months;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    // Adjust day if it exceeds the new month's length
    final maxDay = _getMonthLength(newYear, newMonth);
    final newDay = day > maxDay ? maxDay : day;

    return ImperialPersianDate(
      newYear,
      newMonth,
      newDay,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
    );
  }

  /// Adds the specified number of days.
  ImperialPersianDate addDays(int days) {
    final jdn = toJulianDayNumber() + days;
    return ImperialPersianDate.fromJulianDayNumber(
      jdn,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
    );
  }

  /// Returns the difference in days between this date and [other].
  int difference(ImperialPersianDate other) {
    return toJulianDayNumber() - other.toJulianDayNumber();
  }

  /// Checks if this date is before [other].
  bool isBefore(ImperialPersianDate other) {
    return compareTo(other) < 0;
  }

  /// Checks if this date is after [other].
  bool isAfter(ImperialPersianDate other) {
    return compareTo(other) > 0;
  }

  /// Checks if this date is at the same moment as [other].
  bool isAtSameMomentAs(ImperialPersianDate other) {
    return compareTo(other) == 0;
  }

  /// Formats the date according to the given pattern.
  ///
  /// Supported patterns:
  /// - YYYY: 4-digit year (e.g., 2604)
  /// - YY: 2-digit year (e.g., 04)
  /// - MMMM: Full month name in Farsi (e.g., بهمن)
  /// - MMME: Full month name in English (e.g., Bahman)
  /// - MMM: Abbreviated month name (e.g., بهم)
  /// - MM: 2-digit month (e.g., 12)
  /// - M: Month without leading zero (e.g., 12)
  /// - DD: 2-digit day (e.g., 06)
  /// - D: Day without leading zero (e.g., 6)
  /// - WWWW: Full weekday name in Farsi (e.g., جمعه)
  /// - WWWE: Full weekday name in English (e.g., Jomeh)
  /// - WWW: Abbreviated weekday name (e.g., جمع)
  /// - HH: 2-digit hour (e.g., 09)
  /// - H: Hour without leading zero (e.g., 9)
  /// - mm: 2-digit minute (e.g., 05)
  /// - m: Minute without leading zero (e.g., 5)
  /// - ss: 2-digit second (e.g., 03)
  /// - s: Second without leading zero (e.g., 3)
  ///
  /// Example:
  /// ```dart
  /// final date = ImperialPersianDate(2584, 12, 5);
  /// print(date.format('YYYY/MM/DD')); // 2584/12/05
  /// print(date.format('WWWW DD MMMM YYYY')); // سه‌شنبه 05 اسفند 2584
  /// ```
  String format(String pattern) {
    return ImperialPersianFormatter.format(this, pattern);
  }

  @override
  int compareTo(ImperialPersianDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    if (day != other.day) return day.compareTo(other.day);
    if (hour != other.hour) return hour.compareTo(other.hour);
    if (minute != other.minute) return minute.compareTo(other.minute);
    if (second != other.second) return second.compareTo(other.second);
    return millisecond.compareTo(other.millisecond);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImperialPersianDate &&
        year == other.year &&
        month == other.month &&
        day == other.day &&
        hour == other.hour &&
        minute == other.minute &&
        second == other.second &&
        millisecond == other.millisecond;
  }

  @override
  int get hashCode {
    return Object.hash(year, month, day, hour, minute, second, millisecond);
  }

  @override
  String toString() {
    return '$year/$month/$day';
  }

  /// Returns a string representation with time.
  String toStringWithTime() {
    return '$year/$month/$day ${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:'
        '${second.toString().padLeft(2, '0')}';
  }

  // ============================================================================
  // Private helper methods
  // ============================================================================

  static bool _isValidDate(int year, int month, int day) {
    if (month < 1 || month > 12) return false;
    if (day < 1) return false;
    final maxDay = _getMonthLength(year, month);
    return day <= maxDay;
  }

  static int _getMonthLength(int year, int month) {
    if (month == 12) {
      final shamsiYear = year - imperialOffset;
      return _isLeapShamsiYear(shamsiYear) ? 30 : 29;
    }
    return month <= 6 ? 31 : 30;
  }

  static bool _isLeapShamsiYear(int shamsiYear) {
    // 33-year cycle algorithm for Persian calendar
    final breaks = [
      -61,
      9,
      38,
      199,
      426,
      686,
      756,
      818,
      1111,
      1181,
      1210,
      1635,
      2060,
      2097,
      2192,
      2262,
      2324,
      2394,
      2456,
      3178
    ];

    int jp = breaks[0];
    int jump = 0;
    for (int j = 1; j < breaks.length; j++) {
      final jm = breaks[j];
      jump = jm - jp;
      if (shamsiYear < jm) break;
      jp = jm;
    }

    int n = shamsiYear - jp;
    if (jump - n < 6) n = n - jump + (jump + 4) ~/ 33 * 33;

    int leap = ((n + 1) % 33 - 1) % 4;
    if (leap == -1) leap = 4;

    return leap == 0;
  }

  static List<int> _gregorianToShamsi(int gy, int gm, int gd) {
    final jdn = _gregorianToJulianDayNumber(gy, gm, gd);
    return _julianDayNumberToShamsi(jdn);
  }

  static List<int> _shamsiToGregorian(int jy, int jm, int jd) {
    final jdn = _shamsiToJulianDayNumber(jy, jm, jd);
    return _julianDayNumberToGregorian(jdn);
  }

  static int _gregorianToJulianDayNumber(int gy, int gm, int gd) {
    int a = (14 - gm) ~/ 12;
    int y = gy + 4800 - a;
    int m = gm + 12 * a - 3;
    return gd +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  static List<int> _julianDayNumberToGregorian(int jdn) {
    int a = jdn + 32044;
    int b = (4 * a + 3) ~/ 146097;
    int c = a - (146097 * b) ~/ 4;
    int d = (4 * c + 3) ~/ 1461;
    int e = c - (1461 * d) ~/ 4;
    int m = (5 * e + 2) ~/ 153;
    int day = e - (153 * m + 2) ~/ 5 + 1;
    int month = m + 3 - 12 * (m ~/ 10);
    int year = 100 * b + d - 4800 + m ~/ 10;
    return [year, month, day];
  }

  static int _shamsiToJulianDayNumber(int jy, int jm, int jd) {
    final breaks = [
      -61,
      9,
      38,
      199,
      426,
      686,
      756,
      818,
      1111,
      1181,
      1210,
      1635,
      2060,
      2097,
      2192,
      2262,
      2324,
      2394,
      2456,
      3178
    ];

    int jp = breaks[0];
    int jump = 0;
    for (int j = 1; j < breaks.length; j++) {
      final jm = breaks[j];
      jump = jm - jp;
      if (jy < jm) break;
      jp = jm;
    }

    int n = jy - jp;
    if (jump - n < 6) n = n - jump + (jump + 4) ~/ 33 * 33;

    int leap = ((n + 1) % 33 - 1) % 4;
    if (leap == -1) leap = 4;

    int gy = jy + 621;
    int march = leap == 0 ? 20 : 21;
    if (jump - n < 6) march += (jump + 4) ~/ 33 - 1;

    int jdn = _gregorianToJulianDayNumber(gy, 3, march);
    if (jm > 1) jdn += 31;
    if (jm > 2) jdn += 31;
    if (jm > 3) jdn += 31;
    if (jm > 4) jdn += 31;
    if (jm > 5) jdn += 31;
    if (jm > 6) jdn += 31;
    if (jm > 7) jdn += 30;
    if (jm > 8) jdn += 30;
    if (jm > 9) jdn += 30;
    if (jm > 10) jdn += 30;
    if (jm > 11) jdn += 30;
    jdn += jd - 1;

    return jdn;
  }

  static List<int> _julianDayNumberToShamsi(int jdn) {
    int gy = _julianDayNumberToGregorian(jdn)[0];
    int jy = gy - 621;

    final breaks = [
      -61,
      9,
      38,
      199,
      426,
      686,
      756,
      818,
      1111,
      1181,
      1210,
      1635,
      2060,
      2097,
      2192,
      2262,
      2324,
      2394,
      2456,
      3178
    ];

    int jp = breaks[0];
    int jump = 0;
    for (int j = 1; j < breaks.length; j++) {
      final jm = breaks[j];
      jump = jm - jp;
      if (jy < jm) break;
      jp = jm;
    }

    int n = jy - jp;
    if (jump - n < 6) n = n - jump + (jump + 4) ~/ 33 * 33;

    int leap = ((n + 1) % 33 - 1) % 4;
    if (leap == -1) leap = 4;

    int march = leap == 0 ? 20 : 21;
    if (jump - n < 6) march += (jump + 4) ~/ 33 - 1;

    int jdnFarvardin1 = _gregorianToJulianDayNumber(gy, 3, march);

    int diff = jdn - jdnFarvardin1;
    if (diff >= 0) {
      if (diff <= 185) {
        int jm = 1 + diff ~/ 31;
        int jd = 1 + (diff % 31);
        return [jy, jm, jd];
      } else {
        diff -= 186;
        int jm = 7 + diff ~/ 30;
        int jd = 1 + (diff % 30);
        return [jy, jm, jd];
      }
    } else {
      jy--;
      diff += 179;
      if (_isLeapShamsiYear(jy)) diff++;
      int jm = 7 + diff ~/ 30;
      int jd = 1 + (diff % 30);
      return [jy, jm, jd];
    }
  }
}
