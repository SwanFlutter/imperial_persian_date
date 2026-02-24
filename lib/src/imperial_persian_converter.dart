/// Conversion utilities for the Imperial Persian calendar package.
///
/// Provides static methods for converting between Gregorian, Shamsi (Solar Hijri),
/// and Imperial Persian date systems.
library;

/// Handles all date conversion logic between calendar systems.
class ImperialPersianConverter {
  /// The offset to add to a Shamsi year to obtain the Imperial Persian year.
  static const int imperialOffset = 1180;

  // Private month-day tables used in Shamsi conversion algorithms.
  static const List<int> _gDaysInMonth = [
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  ];
  static const List<int> _jDaysInMonth = [
    31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29
  ];

  // ---------------------------------------------------------------------------
  // Core low-level algorithms
  // ---------------------------------------------------------------------------

  /// Converts a Gregorian date to a Shamsi (Solar Hijri / Jalali) date.
  ///
  /// Returns a [List] of three integers: [year, month, day].
  static List<int> gregorianToShamsi(int gy, int gm, int gd) {
    int jy, jm, jd;
    int gy2, gm2, gd2;
    int gDayNo, jDayNo;
    int i;

    gy2 = gy - 1600;
    gm2 = gm - 1;
    gd2 = gd - 1;

    gDayNo = 365 * gy2 +
        (gy2 + 3) ~/ 4 -
        (gy2 + 99) ~/ 100 +
        (gy2 + 399) ~/ 400;
    for (i = 0; i < gm2; ++i) {
      gDayNo += _gDaysInMonth[i];
    }
    if (gm2 > 1 &&
        ((gy % 4 == 0 && gy % 100 != 0) || (gy % 400 == 0))) {
      ++gDayNo;
    }
    gDayNo += gd2;

    jDayNo = gDayNo - 79;

    final jNp = jDayNo ~/ 12053;
    jDayNo = jDayNo % 12053;

    jy = 979 + 33 * jNp + 4 * (jDayNo ~/ 1461);
    jDayNo %= 1461;

    if (jDayNo >= 366) {
      jy += (jDayNo - 1) ~/ 365;
      jDayNo = (jDayNo - 1) % 365;
    }

    for (i = 0; i < 11 && jDayNo >= _jDaysInMonth[i]; ++i) {
      jDayNo -= _jDaysInMonth[i];
    }
    jm = i + 1;
    jd = jDayNo + 1;

    return [jy, jm, jd];
  }

  /// Converts a Shamsi (Solar Hijri / Jalali) date to a Gregorian date.
  ///
  /// Returns a [List] of three integers: [year, month, day].
  static List<int> shamsiToGregorian(int jy, int jm, int jd) {
    int gy, gm, gd;
    int gDayNo, jDayNo;
    bool leap;
    int i;

    jy -= 979;
    jm -= 1;
    jd -= 1;

    jDayNo = 365 * jy + (jy ~/ 33) * 8 + (jy % 33 + 3) ~/ 4;
    for (i = 0; i < jm; ++i) {
      jDayNo += _jDaysInMonth[i];
    }
    jDayNo += jd;

    gDayNo = jDayNo + 79;

    gy = 1600 + 400 * (gDayNo ~/ 146097);
    gDayNo = gDayNo % 146097;

    leap = true;
    if (gDayNo >= 36525) {
      gDayNo--;
      gy += 100 * (gDayNo ~/ 36524);
      gDayNo = gDayNo % 36524;

      if (gDayNo >= 365) {
        gDayNo++;
      } else {
        leap = false;
      }
    }

    gy += 4 * (gDayNo ~/ 1461);
    gDayNo %= 1461;

    if (gDayNo >= 366) {
      leap = false;
      gDayNo--;
      gy += gDayNo ~/ 365;
      gDayNo = gDayNo % 365;
    }

    for (i = 0;
        gDayNo >= _gDaysInMonth[i] + (i == 1 && leap ? 1 : 0);
        i++) {
      gDayNo -= _gDaysInMonth[i] + (i == 1 && leap ? 1 : 0);
    }
    gm = i + 1;
    gd = gDayNo + 1;

    return [gy, gm, gd];
  }

  // ---------------------------------------------------------------------------
  // Imperial Persian conversions
  // ---------------------------------------------------------------------------

  /// Converts an Imperial Persian date to a Shamsi date.
  ///
  /// Returns a [List] of three integers: [shamsiYear, month, day].
  static List<int> imperialToShamsi(int iy, int im, int id) {
    return [iy - imperialOffset, im, id];
  }

  /// Converts a Shamsi date to an Imperial Persian date.
  ///
  /// Returns a [List] of three integers: [imperialYear, month, day].
  static List<int> shamsiToImperial(int jy, int jm, int jd) {
    return [jy + imperialOffset, jm, jd];
  }

  /// Converts an Imperial Persian date to a Gregorian [DateTime].
  static DateTime imperialToGregorian(int iy, int im, int id,
      {int hour = 0, int minute = 0, int second = 0}) {
    final shamsi = imperialToShamsi(iy, im, id);
    final greg = shamsiToGregorian(shamsi[0], shamsi[1], shamsi[2]);
    return DateTime(greg[0], greg[1], greg[2], hour, minute, second);
  }

  /// Converts a Gregorian [DateTime] to an Imperial Persian date.
  ///
  /// Returns a [List] of three integers: [imperialYear, month, day].
  static List<int> gregorianToImperial(int gy, int gm, int gd) {
    final shamsi = gregorianToShamsi(gy, gm, gd);
    return shamsiToImperial(shamsi[0], shamsi[1], shamsi[2]);
  }

  // ---------------------------------------------------------------------------
  // Leap year helpers
  // ---------------------------------------------------------------------------

  /// Returns [true] if the given Shamsi [year] is a leap year.
  static bool isShamsiLeapYear(int year) {
    // Algorithmic leap-year test for the Shamsi calendar.
    final List<int> leapRemainders = [1, 5, 9, 13, 17, 22, 26, 30];
    return leapRemainders.contains(((year - 474) % 2820 + 474 + 38) * 682 % 2816);
  }

  /// Returns [true] if the given Imperial Persian [year] is a leap year.
  static bool isImperialLeapYear(int year) {
    return isShamsiLeapYear(year - imperialOffset);
  }

  /// Returns the number of days in the given Shamsi [month] of [year].
  static int daysInShamsiMonth(int year, int month) {
    if (month <= 6) return 31;
    if (month <= 11) return 30;
    return isShamsiLeapYear(year) ? 30 : 29;
  }

  /// Returns the number of days in the given Imperial Persian [month] of [year].
  static int daysInImperialMonth(int year, int month) {
    return daysInShamsiMonth(year - imperialOffset, month);
  }
}
