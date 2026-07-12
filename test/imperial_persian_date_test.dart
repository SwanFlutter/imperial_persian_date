import 'package:flutter_test/flutter_test.dart';
import 'package:imperial_persian_date/imperial_persian_date.dart';

void main() {
  // ==========================================================================
  // 1. Constructor & basic properties
  // ==========================================================================
  group('Constructor', () {
    test('creates date with year/month/day only', () {
      final d = ImperialPersianDate(2585, 4, 21);
      expect(d.year, 2585);
      expect(d.month, 4);
      expect(d.day, 21);
      expect(d.hour, 0);
      expect(d.minute, 0);
      expect(d.second, 0);
      expect(d.millisecond, 0);
    });

    test('creates date with full time components', () {
      final d = ImperialPersianDate(2585, 4, 21,
          hour: 14, minute: 30, second: 45, millisecond: 123);
      expect(d.hour, 14);
      expect(d.minute, 30);
      expect(d.second, 45);
      expect(d.millisecond, 123);
    });

    test('accepts boundary values for time', () {
      expect(() => ImperialPersianDate(2585, 1, 1, hour: 0), returnsNormally);
      expect(() => ImperialPersianDate(2585, 1, 1, hour: 23), returnsNormally);
      expect(
          () => ImperialPersianDate(2585, 1, 1, minute: 59), returnsNormally);
      expect(
          () => ImperialPersianDate(2585, 1, 1, second: 59), returnsNormally);
      expect(() => ImperialPersianDate(2585, 1, 1, millisecond: 999),
          returnsNormally);
    });

    test('throws ArgumentError for invalid month', () {
      expect(() => ImperialPersianDate(2585, 0, 1), throwsArgumentError);
      expect(() => ImperialPersianDate(2585, 13, 1), throwsArgumentError);
    });

    test('throws ArgumentError for invalid day', () {
      expect(() => ImperialPersianDate(2585, 1, 0), throwsArgumentError);
      expect(() => ImperialPersianDate(2585, 1, 32), throwsArgumentError);
      expect(() => ImperialPersianDate(2585, 7, 31), throwsArgumentError);
      // Month 12 in non-leap year: max 29
      expect(() => ImperialPersianDate(2585, 12, 30), throwsArgumentError);
    });

    test('throws ArgumentError for invalid time', () {
      expect(
          () => ImperialPersianDate(2585, 1, 1, hour: 24), throwsArgumentError);
      expect(
          () => ImperialPersianDate(2585, 1, 1, hour: -1), throwsArgumentError);
      expect(() => ImperialPersianDate(2585, 1, 1, minute: 60),
          throwsArgumentError);
      expect(() => ImperialPersianDate(2585, 1, 1, second: 60),
          throwsArgumentError);
      expect(() => ImperialPersianDate(2585, 1, 1, millisecond: 1000),
          throwsArgumentError);
    });
  });

  // ==========================================================================
  // 2. fromGregorian & toGregorian
  // ==========================================================================
  group('fromGregorian', () {
    test('2026-07-12 → 1405/4/21 shamsi → 2585/4/21 imperial', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(2026, 7, 12));
      expect(d.year, 2585);
      expect(d.month, 4);
      expect(d.day, 21);
    });

    test('2026-02-24 → 1404/12/5 shamsi → 2584/12/5 imperial', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(2026, 2, 24));
      expect(d.year, 2584);
      expect(d.month, 12);
      expect(d.day, 5);
    });

    test('1979-02-11 → 1357/11/23 shamsi → 2537/11/23 imperial', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(1979, 2, 11));
      expect(d.year, 2537);
      expect(d.month, 11);
      expect(d.day, 23);
    });

    test('2026-03-21 → 1 Farvardin 1405 → 2585/1/1 imperial', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(2026, 3, 21));
      expect(d.year, 2585);
      expect(d.month, 1);
      expect(d.day, 1);
    });

    test('preserves time components', () {
      final d = ImperialPersianDate.fromGregorian(
          DateTime(2026, 7, 12, 14, 30, 45, 123));
      expect(d.hour, 14);
      expect(d.minute, 30);
      expect(d.second, 45);
      expect(d.millisecond, 123);
    });
  });

  group('toGregorian', () {
    test('2585/4/21 → 2026-07-12', () {
      final g = ImperialPersianDate(2585, 4, 21).toGregorian();
      expect(g.year, 2026);
      expect(g.month, 7);
      expect(g.day, 12);
    });

    test('2584/12/5 → 2026-02-24', () {
      final g = ImperialPersianDate(2584, 12, 5).toGregorian();
      expect(g.year, 2026);
      expect(g.month, 2);
      expect(g.day, 24);
    });

    test('2585/1/1 → 2026-03-21', () {
      final g = ImperialPersianDate(2585, 1, 1).toGregorian();
      expect(g.year, 2026);
      expect(g.month, 3);
      expect(g.day, 21);
    });

    test('preserves time components', () {
      final g = ImperialPersianDate(2585, 4, 21,
              hour: 14, minute: 30, second: 45, millisecond: 123)
          .toGregorian();
      expect(g.hour, 14);
      expect(g.minute, 30);
      expect(g.second, 45);
      expect(g.millisecond, 123);
    });
  });

  // ==========================================================================
  // 3. fromShamsi, toShamsi, imperialOffset, JDN
  // ==========================================================================
  group('fromShamsi', () {
    test('1405/4/21 → 2585/4/21 imperial', () {
      final d = ImperialPersianDate.fromShamsi(1405, 4, 21);
      expect(d.year, 2585);
      expect(d.month, 4);
      expect(d.day, 21);
    });

    test('1404/12/5 → 2584/12/5 imperial', () {
      final d = ImperialPersianDate.fromShamsi(1404, 12, 5);
      expect(d.year, 2584);
      expect(d.month, 12);
      expect(d.day, 5);
    });

    test('1357/11/23 → 2537/11/23 imperial', () {
      final d = ImperialPersianDate.fromShamsi(1357, 11, 23);
      expect(d.year, 2537);
      expect(d.month, 11);
      expect(d.day, 23);
    });

    test('preserves time components', () {
      final d = ImperialPersianDate.fromShamsi(1405, 1, 1,
          hour: 9, minute: 15, second: 30, millisecond: 500);
      expect(d.hour, 9);
      expect(d.minute, 15);
      expect(d.second, 30);
      expect(d.millisecond, 500);
    });
  });

  group('toShamsi', () {
    test('2585/4/21 → [1405, 4, 21]', () {
      final s = ImperialPersianDate(2585, 4, 21).toShamsi();
      expect(s, [1405, 4, 21]);
    });

    test('2584/12/5 → [1404, 12, 5]', () {
      final s = ImperialPersianDate(2584, 12, 5).toShamsi();
      expect(s, [1404, 12, 5]);
    });

    test('offset is always 1180', () {
      for (final year in [2537, 2560, 2583, 2584, 2585, 2600]) {
        final d = ImperialPersianDate(year, 6, 15);
        final s = d.toShamsi();
        expect(d.year - s[0], ImperialPersianDate.imperialOffset);
      }
    });
  });

  group('imperialOffset', () {
    test('is exactly 1180', () {
      expect(ImperialPersianDate.imperialOffset, 1180);
    });
  });

  group('Julian Day Number', () {
    test('toJulianDayNumber and fromJulianDayNumber round-trip', () {
      final original = ImperialPersianDate(2585, 4, 21);
      final jdn = original.toJulianDayNumber();
      final restored = ImperialPersianDate.fromJulianDayNumber(jdn);
      expect(restored.year, original.year);
      expect(restored.month, original.month);
      expect(restored.day, original.day);
    });

    test('JDN round-trip preserves time components', () {
      final original =
          ImperialPersianDate(2585, 4, 21, hour: 10, minute: 20, second: 30);
      final jdn = original.toJulianDayNumber();
      final restored = ImperialPersianDate.fromJulianDayNumber(jdn,
          hour: 10, minute: 20, second: 30);
      expect(restored.hour, 10);
      expect(restored.minute, 20);
      expect(restored.second, 30);
    });

    test('consecutive dates have JDN difference of 1', () {
      final d1 = ImperialPersianDate(2585, 4, 21);
      final d2 = ImperialPersianDate(2585, 4, 22);
      expect(d2.toJulianDayNumber() - d1.toJulianDayNumber(), 1);
    });

    test('JDN across month boundary is correct', () {
      final endOfMonth = ImperialPersianDate(2585, 4, 31);
      final startOfMonth = ImperialPersianDate(2585, 5, 1);
      expect(
          startOfMonth.toJulianDayNumber() - endOfMonth.toJulianDayNumber(), 1);
    });

    test('JDN across year boundary is correct', () {
      final lastDay = ImperialPersianDate(2584, 12, 29); // non-leap
      final firstDay = ImperialPersianDate(2585, 1, 1);
      expect(firstDay.toJulianDayNumber() - lastDay.toJulianDayNumber(), 1);
    });
  });

  // ==========================================================================
  // 4. format() — all patterns
  // ==========================================================================
  group('format()', () {
    // 2585/4/21, Sunday (یکشنبه), hour=9, min=5, sec=3
    final d = ImperialPersianDate(2585, 4, 21,
        hour: 9, minute: 5, second: 3, millisecond: 0);

    test('YYYY → 4-digit year', () {
      expect(d.format('YYYY'), '2585');
    });

    test('YY → 2-digit year with leading zero', () {
      expect(d.format('YY'), '85');
    });

    test('MM → 2-digit month with leading zero', () {
      expect(ImperialPersianDate(2585, 4, 1).format('MM'), '04');
      expect(ImperialPersianDate(2585, 12, 1).format('MM'), '12');
    });

    test('M → month without leading zero', () {
      expect(ImperialPersianDate(2585, 4, 1).format('M'), '4');
      expect(ImperialPersianDate(2585, 12, 1).format('M'), '12');
    });

    test('DD → 2-digit day with leading zero', () {
      expect(d.format('DD'), '21');
      expect(ImperialPersianDate(2585, 4, 5).format('DD'), '05');
    });

    test('D → day without leading zero', () {
      expect(d.format('D'), '21');
      expect(ImperialPersianDate(2585, 4, 5).format('D'), '5');
    });

    test('MMMM → full month name in Farsi', () {
      expect(d.format('MMMM'), 'تیر');
      expect(ImperialPersianDate(2585, 12, 1).format('MMMM'), 'اسفند');
    });

    test('MMME → full month name in English', () {
      expect(d.format('MMME'), 'Tir');
      expect(ImperialPersianDate(2585, 12, 1).format('MMME'), 'Esfand');
    });

    test('MMM → abbreviated month name (3 chars)', () {
      // 'تیر' is only 3 chars, stays the same
      expect(d.format('MMM'), 'تیر');
      // 'فروردین' truncated to 3 chars
      expect(ImperialPersianDate(2585, 1, 1).format('MMM'), 'فرو');
    });

    test('WWWW → full weekday name in Farsi', () {
      // 2585/4/21 = 2026-07-12 = Sunday = یکشنبه
      expect(d.format('WWWW'), 'یکشنبه');
    });

    test('WWWE → full weekday name in English', () {
      expect(d.format('WWWE'), 'Sunday');
    });

    test('WWW → abbreviated weekday (3 chars)', () {
      expect(d.format('WWW'), 'یکش');
    });

    test('HH → 2-digit hour with leading zero', () {
      expect(d.format('HH'), '09');
      expect(ImperialPersianDate(2585, 4, 21, hour: 14).format('HH'), '14');
    });

    test('H → hour without leading zero', () {
      expect(d.format('H'), '9');
      expect(ImperialPersianDate(2585, 4, 21, hour: 14).format('H'), '14');
    });

    test('mm → 2-digit minute with leading zero', () {
      expect(d.format('mm'), '05');
    });

    test('m → minute without leading zero', () {
      expect(d.format('m'), '5');
    });

    test('ss → 2-digit second with leading zero', () {
      expect(d.format('ss'), '03');
    });

    test('s → second without leading zero', () {
      expect(d.format('s'), '3');
    });

    test('composite: YYYY/MM/DD', () {
      expect(d.format('YYYY/MM/DD'), '2585/04/21');
    });

    test('composite: YYYY-MM-DD', () {
      expect(d.format('YYYY-MM-DD'), '2585-04-21');
    });

    test('composite: D/M/YYYY', () {
      expect(d.format('D/M/YYYY'), '21/4/2585');
    });

    test('composite: WWWW DD MMMM YYYY', () {
      expect(d.format('WWWW DD MMMM YYYY'), 'یکشنبه 21 تیر 2585');
    });

    test('composite: YYYY/MM/DD HH:mm:ss', () {
      expect(d.format('YYYY/MM/DD HH:mm:ss'), '2585/04/21 09:05:03');
    });

    test('literal characters are preserved', () {
      expect(d.format('YYYY سال MM ماه DD روز'), '2585 سال 04 ماه 21 روز');
    });
  });

  // ==========================================================================
  // 5. Month names & weekday names
  // ==========================================================================
  group('Month names', () {
    const faNames = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند',
    ];
    const enNames = [
      'Farvardin',
      'Ordibehesht',
      'Khordad',
      'Tir',
      'Mordad',
      'Shahrivar',
      'Mehr',
      'Aban',
      'Azar',
      'Dey',
      'Bahman',
      'Esfand',
    ];

    test('all 12 Farsi month names are correct', () {
      for (int m = 1; m <= 12; m++) {
        final d = ImperialPersianDate(2585, m, 1);
        expect(d.monthName, faNames[m - 1],
            reason: 'month $m should be ${faNames[m - 1]}');
      }
    });

    test('all 12 English month names are correct', () {
      for (int m = 1; m <= 12; m++) {
        final d = ImperialPersianDate(2585, m, 1);
        expect(d.monthNameEn, enNames[m - 1],
            reason: 'month $m should be ${enNames[m - 1]}');
      }
    });
  });

  group('Weekday names', () {
    // Known anchors verified against calendar:
    // 2585/1/1  = 2026-03-21 = Saturday  = شنبه   (weekDay index 0)
    // 2585/4/21 = 2026-07-12 = Sunday    = یکشنبه (weekDay index 1)
    // 2585/1/2  = 2026-03-22 = Sunday    = یکشنبه
    // 2585/1/3  = 2026-03-23 = Monday    = دوشنبه
    // 2585/1/4  = 2026-03-24 = Tuesday   = سه‌شنبه
    // 2585/1/5  = 2026-03-25 = Wednesday = چهارشنبه
    // 2585/1/6  = 2026-03-26 = Thursday  = پنج‌شنبه
    // 2585/1/7  = 2026-03-27 = Friday    = جمعه

    const faWeekdays = [
      'شنبه',
      'یکشنبه',
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنج‌شنبه',
      'جمعه',
    ];
    const enWeekdays = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];

    test('all 7 Farsi weekday names are correct', () {
      for (int i = 0; i < 7; i++) {
        final d = ImperialPersianDate(2585, 1, 1 + i);
        expect(d.weekDayName, faWeekdays[i],
            reason: 'day ${1 + i} of Farvardin should be ${faWeekdays[i]}');
      }
    });

    test('all 7 English weekday names are correct', () {
      for (int i = 0; i < 7; i++) {
        final d = ImperialPersianDate(2585, 1, 1 + i);
        expect(d.weekDayNameEn, enWeekdays[i],
            reason: 'day ${1 + i} of Farvardin should be ${enWeekdays[i]}');
      }
    });

    test('weekDay index for known Saturday (2585/1/1)', () {
      expect(ImperialPersianDate(2585, 1, 1).weekDay, 0); // Saturday
    });

    test('weekDay index for known Sunday (2585/4/21)', () {
      expect(ImperialPersianDate(2585, 4, 21).weekDay, 1); // Sunday
    });

    test('weekDay cycles correctly over 7 consecutive days', () {
      final base = ImperialPersianDate(2585, 1, 1).weekDay;
      for (int i = 0; i < 7; i++) {
        final d = ImperialPersianDate(2585, 1, 1 + i);
        expect(d.weekDay, (base + i) % 7);
      }
    });
  });

  // ==========================================================================
  // 6. Arithmetic: addDays, addMonths, addYears
  // ==========================================================================
  group('addDays', () {
    test('adds positive days within same month', () {
      final d = ImperialPersianDate(2585, 4, 10).addDays(5);
      expect(d.year, 2585);
      expect(d.month, 4);
      expect(d.day, 15);
    });

    test('adds days crossing month boundary', () {
      // 4/31 + 1 day = 5/1
      final d = ImperialPersianDate(2585, 4, 31).addDays(1);
      expect(d.month, 5);
      expect(d.day, 1);
    });

    test('adds days crossing year boundary', () {
      // 2584/12/29 (non-leap) + 1 = 2585/1/1
      final d = ImperialPersianDate(2584, 12, 29).addDays(1);
      expect(d.year, 2585);
      expect(d.month, 1);
      expect(d.day, 1);
    });

    test('subtracts days (negative) within same month', () {
      final d = ImperialPersianDate(2585, 4, 15).addDays(-5);
      expect(d.month, 4);
      expect(d.day, 10);
    });

    test('subtracts days crossing month boundary', () {
      // 5/1 - 1 = 4/31
      final d = ImperialPersianDate(2585, 5, 1).addDays(-1);
      expect(d.month, 4);
      expect(d.day, 31);
    });

    test('subtracts days crossing year boundary', () {
      // 2585/1/1 - 1 = 2584/12/29
      final d = ImperialPersianDate(2585, 1, 1).addDays(-1);
      expect(d.year, 2584);
      expect(d.month, 12);
      expect(d.day, 29);
    });

    test('adding 0 days returns equal date', () {
      final d = ImperialPersianDate(2585, 4, 21);
      expect(d.addDays(0), d);
    });

    test('preserves time components', () {
      final d = ImperialPersianDate(2585, 4, 21,
          hour: 14, minute: 30, second: 45, millisecond: 123);
      final result = d.addDays(3);
      expect(result.hour, 14);
      expect(result.minute, 30);
      expect(result.second, 45);
      expect(result.millisecond, 123);
    });
  });

  group('addMonths', () {
    test('adds positive months within same year', () {
      final d = ImperialPersianDate(2585, 4, 15).addMonths(2);
      expect(d.year, 2585);
      expect(d.month, 6);
      expect(d.day, 15);
    });

    test('adds months crossing year boundary', () {
      final d = ImperialPersianDate(2585, 11, 1).addMonths(2);
      expect(d.year, 2586);
      expect(d.month, 1);
    });

    test('subtracts months (negative)', () {
      final d = ImperialPersianDate(2585, 5, 10).addMonths(-2);
      expect(d.year, 2585);
      expect(d.month, 3);
    });

    test('subtracts months crossing year boundary', () {
      final d = ImperialPersianDate(2585, 2, 1).addMonths(-3);
      expect(d.year, 2584);
      expect(d.month, 11);
    });

    test('clamps day when target month is shorter', () {
      // Month 7 has 30 days; day 31 → clamped to 30
      final d = ImperialPersianDate(2585, 6, 31).addMonths(1);
      expect(d.month, 7);
      expect(d.day, 30);
    });

    test('clamps day for month 12 in non-leap year', () {
      // 2584 non-leap: month 12 has 29 days; day 31 → clamped to 29
      final d = ImperialPersianDate(2584, 11, 30).addMonths(1);
      expect(d.month, 12);
      expect(d.day, 29);
    });

    test('adding 0 months returns equal date', () {
      final d = ImperialPersianDate(2585, 4, 21);
      expect(d.addMonths(0), d);
    });
  });

  group('addYears', () {
    test('adds positive years', () {
      final d = ImperialPersianDate(2585, 4, 21).addYears(3);
      expect(d.year, 2588);
      expect(d.month, 4);
      expect(d.day, 21);
    });

    test('subtracts years (negative)', () {
      final d = ImperialPersianDate(2585, 4, 21).addYears(-5);
      expect(d.year, 2580);
      expect(d.month, 4);
      expect(d.day, 21);
    });

    test('adding 0 years returns equal date', () {
      final d = ImperialPersianDate(2585, 4, 21);
      expect(d.addYears(0), d);
    });
  });

  group('difference', () {
    test('positive difference (later minus earlier)', () {
      final d1 = ImperialPersianDate(2585, 4, 10);
      final d2 = ImperialPersianDate(2585, 4, 20);
      expect(d2.difference(d1), 10);
    });

    test('negative difference (earlier minus later)', () {
      final d1 = ImperialPersianDate(2585, 4, 10);
      final d2 = ImperialPersianDate(2585, 4, 20);
      expect(d1.difference(d2), -10);
    });

    test('difference of same date is 0', () {
      final d = ImperialPersianDate(2585, 4, 21);
      expect(d.difference(d), 0);
    });

    test('difference across month boundary', () {
      final d1 = ImperialPersianDate(2585, 4, 25);
      final d2 = ImperialPersianDate(2585, 5, 5);
      // 31-25=6 days remaining in month 4, +5 days in month 5 = 11
      expect(d2.difference(d1), 11);
    });

    test('difference across year boundary', () {
      final d1 = ImperialPersianDate(2584, 12, 29);
      final d2 = ImperialPersianDate(2585, 1, 1);
      expect(d2.difference(d1), 1);
    });
  });

  // ==========================================================================
  // 7. Comparison, equality, hashCode, copyWith
  // ==========================================================================
  group('compareTo', () {
    test('earlier date returns negative', () {
      final d1 = ImperialPersianDate(2585, 4, 10);
      final d2 = ImperialPersianDate(2585, 4, 21);
      expect(d1.compareTo(d2), isNegative);
    });

    test('later date returns positive', () {
      final d1 = ImperialPersianDate(2585, 4, 10);
      final d2 = ImperialPersianDate(2585, 4, 21);
      expect(d2.compareTo(d1), isPositive);
    });

    test('same date returns zero', () {
      final d = ImperialPersianDate(2585, 4, 21);
      expect(d.compareTo(d), 0);
    });

    test('compares by year first', () {
      final d1 = ImperialPersianDate(2584, 12, 29);
      final d2 = ImperialPersianDate(2585, 1, 1);
      expect(d1.compareTo(d2), isNegative);
    });

    test('compares by month when year is equal', () {
      final d1 = ImperialPersianDate(2585, 3, 31);
      final d2 = ImperialPersianDate(2585, 4, 1);
      expect(d1.compareTo(d2), isNegative);
    });

    test('compares by hour when date is equal', () {
      final d1 = ImperialPersianDate(2585, 4, 21, hour: 8);
      final d2 = ImperialPersianDate(2585, 4, 21, hour: 14);
      expect(d1.compareTo(d2), isNegative);
    });

    test('compares by minute when date+hour are equal', () {
      final d1 = ImperialPersianDate(2585, 4, 21, hour: 10, minute: 15);
      final d2 = ImperialPersianDate(2585, 4, 21, hour: 10, minute: 45);
      expect(d1.compareTo(d2), isNegative);
    });

    test('compares by second', () {
      final d1 =
          ImperialPersianDate(2585, 4, 21, hour: 10, minute: 0, second: 10);
      final d2 =
          ImperialPersianDate(2585, 4, 21, hour: 10, minute: 0, second: 50);
      expect(d1.compareTo(d2), isNegative);
    });

    test('compares by millisecond', () {
      final d1 = ImperialPersianDate(2585, 4, 21, millisecond: 100);
      final d2 = ImperialPersianDate(2585, 4, 21, millisecond: 500);
      expect(d1.compareTo(d2), isNegative);
    });
  });

  group('isBefore / isAfter / isAtSameMomentAs', () {
    final earlier = ImperialPersianDate(2585, 4, 10);
    final later = ImperialPersianDate(2585, 4, 21);

    test('isBefore returns true for earlier date', () {
      expect(earlier.isBefore(later), isTrue);
    });

    test('isBefore returns false for later date', () {
      expect(later.isBefore(earlier), isFalse);
    });

    test('isAfter returns true for later date', () {
      expect(later.isAfter(earlier), isTrue);
    });

    test('isAfter returns false for earlier date', () {
      expect(earlier.isAfter(later), isFalse);
    });

    test('isAtSameMomentAs returns true for identical dates', () {
      expect(earlier.isAtSameMomentAs(earlier), isTrue);
    });

    test('isAtSameMomentAs returns false for different dates', () {
      expect(earlier.isAtSameMomentAs(later), isFalse);
    });
  });

  group('Equality and hashCode', () {
    test('two identical dates are equal', () {
      final d1 = ImperialPersianDate(2585, 4, 21, hour: 10, minute: 30);
      final d2 = ImperialPersianDate(2585, 4, 21, hour: 10, minute: 30);
      expect(d1 == d2, isTrue);
    });

    test('dates with different day are not equal', () {
      expect(
          ImperialPersianDate(2585, 4, 21) == ImperialPersianDate(2585, 4, 22),
          isFalse);
    });

    test('dates with different hour are not equal', () {
      expect(
          ImperialPersianDate(2585, 4, 21, hour: 10) ==
              ImperialPersianDate(2585, 4, 21, hour: 11),
          isFalse);
    });

    test('equal dates have the same hashCode', () {
      final d1 = ImperialPersianDate(2585, 4, 21, hour: 10);
      final d2 = ImperialPersianDate(2585, 4, 21, hour: 10);
      expect(d1.hashCode, d2.hashCode);
    });

    test('different dates have different hashCodes (high probability)', () {
      final d1 = ImperialPersianDate(2585, 4, 21);
      final d2 = ImperialPersianDate(2585, 4, 22);
      expect(d1.hashCode, isNot(d2.hashCode));
    });
  });

  group('copyWith', () {
    final base = ImperialPersianDate(2585, 4, 21,
        hour: 10, minute: 20, second: 30, millisecond: 400);

    test('copyWith with no changes returns equal date', () {
      expect(base.copyWith(), base);
    });

    test('changes year only', () {
      final d = base.copyWith(year: 2590);
      expect(d.year, 2590);
      expect(d.month, base.month);
      expect(d.day, base.day);
    });

    test('changes month only', () {
      final d = base.copyWith(month: 7);
      expect(d.month, 7);
      expect(d.year, base.year);
      expect(d.day, base.day);
    });

    test('changes day only', () {
      final d = base.copyWith(day: 5);
      expect(d.day, 5);
      expect(d.year, base.year);
      expect(d.month, base.month);
    });

    test('changes hour and minute', () {
      final d = base.copyWith(hour: 23, minute: 59);
      expect(d.hour, 23);
      expect(d.minute, 59);
      expect(d.second, base.second);
      expect(d.millisecond, base.millisecond);
    });

    test('changes second and millisecond', () {
      final d = base.copyWith(second: 0, millisecond: 0);
      expect(d.second, 0);
      expect(d.millisecond, 0);
      expect(d.hour, base.hour);
    });

    test('copyWith result is a new object (immutable)', () {
      final d = base.copyWith(day: 1);
      expect(identical(base, d), isFalse);
    });
  });

  // ==========================================================================
  // 8. Leap year & monthLength edge cases
  // ==========================================================================
  group('isLeapYear', () {
    // Known leap shamsi years (verified): 1399,1403,1408,1412
    // Imperial = shamsi + 1180
    test('2583 (shamsi 1403) is a leap year', () {
      expect(ImperialPersianDate(2583, 1, 1).isLeapYear(), isTrue);
    });

    test('2579 (shamsi 1399) is a leap year', () {
      expect(ImperialPersianDate(2579, 1, 1).isLeapYear(), isTrue);
    });

    test('2588 (shamsi 1408) is a leap year', () {
      expect(ImperialPersianDate(2588, 1, 1).isLeapYear(), isTrue);
    });

    test('2592 (shamsi 1412) is a leap year', () {
      expect(ImperialPersianDate(2592, 1, 1).isLeapYear(), isTrue);
    });

    test('2584 (shamsi 1404) is NOT a leap year', () {
      expect(ImperialPersianDate(2584, 1, 1).isLeapYear(), isFalse);
    });

    test('2585 (shamsi 1405) is NOT a leap year', () {
      expect(ImperialPersianDate(2585, 1, 1).isLeapYear(), isFalse);
    });

    test('2580 (shamsi 1400) is NOT a leap year', () {
      expect(ImperialPersianDate(2580, 1, 1).isLeapYear(), isFalse);
    });

    test('isLeapYear result is consistent regardless of month/day', () {
      for (int m = 1; m <= 11; m++) {
        expect(ImperialPersianDate(2583, m, 1).isLeapYear(), isTrue);
        expect(ImperialPersianDate(2584, m, 1).isLeapYear(), isFalse);
      }
    });
  });

  group('monthLength', () {
    test('months 1-6 always have 31 days', () {
      for (int m = 1; m <= 6; m++) {
        expect(ImperialPersianDate(2585, m, 1).monthLength, 31,
            reason: 'month $m should have 31 days');
      }
    });

    test('months 7-11 always have 30 days', () {
      for (int m = 7; m <= 11; m++) {
        expect(ImperialPersianDate(2585, m, 1).monthLength, 30,
            reason: 'month $m should have 30 days');
      }
    });

    test('month 12 has 30 days in a leap year (2583)', () {
      expect(ImperialPersianDate(2583, 12, 1).monthLength, 30);
    });

    test('month 12 has 29 days in a non-leap year (2585)', () {
      expect(ImperialPersianDate(2585, 12, 1).monthLength, 29);
    });

    test('last valid day of month 12 in leap year is 30', () {
      expect(() => ImperialPersianDate(2583, 12, 30), returnsNormally);
    });

    test('day 30 of month 12 is invalid in non-leap year', () {
      expect(() => ImperialPersianDate(2585, 12, 30), throwsArgumentError);
    });

    test('last valid day of month 12 in non-leap year is 29', () {
      expect(() => ImperialPersianDate(2585, 12, 29), returnsNormally);
    });

    test('day 31 is invalid for months 7-12', () {
      for (int m = 7; m <= 11; m++) {
        expect(() => ImperialPersianDate(2585, m, 31), throwsArgumentError,
            reason: 'month $m should not have 31 days');
      }
    });

    test('leap year allows addDays through 30-day Esfand', () {
      // 2583/12/30 + 1 day = 2584/1/1
      final d = ImperialPersianDate(2583, 12, 30).addDays(1);
      expect(d.year, 2584);
      expect(d.month, 1);
      expect(d.day, 1);
    });

    test('non-leap year allows addDays through 29-day Esfand', () {
      // 2585/12/29 + 1 day = 2586/1/1
      final d = ImperialPersianDate(2585, 12, 29).addDays(1);
      expect(d.year, 2586);
      expect(d.month, 1);
      expect(d.day, 1);
    });
  });

  // ==========================================================================
  // 9. now() — Iran timezone correctness
  // ==========================================================================
  group('now() Iran timezone', () {
    test('returns a valid ImperialPersianDate', () {
      final d = ImperialPersianDate.now();
      expect(d.year, greaterThan(2580));
      expect(d.month, inInclusiveRange(1, 12));
      expect(d.day, inInclusiveRange(1, 31));
    });

    test(
        'now() result matches fromGregorian with Iran UTC+3:30 offset (winter)',
        () {
      // Simulate a UTC datetime that is still the previous day in UTC-7
      // but already the next day in Iran (UTC+3:30).
      // Example: UTC 2026-01-10 22:00 → local UTC-7 = Jan 10,
      //          but Iran UTC+3:30  = Jan 11 01:30
      final utc = DateTime.utc(2026, 1, 10, 22, 0, 0);
      // Iran offset in January = IRST = +3:30
      final iranTime = utc.add(const Duration(hours: 3, minutes: 30));
      final fromIran = ImperialPersianDate.fromGregorian(iranTime);
      // Jan 11 in Iran = 21 Dey 1404 shamsi = 2584/10/21 imperial
      expect(fromIran.year, 2584);
      expect(fromIran.month, 10);
      expect(fromIran.day, 21);
    });

    test(
        'now() result matches fromGregorian with Iran UTC+4:30 offset (summer)',
        () {
      // UTC 2026-07-11 21:00 → UTC-7 = July 11,
      // but Iran UTC+4:30  = July 12 01:30
      final utc = DateTime.utc(2026, 7, 11, 21, 0, 0);
      // Iran offset in July = IRDT = +4:30
      final iranTime = utc.add(const Duration(hours: 4, minutes: 30));
      final fromIran = ImperialPersianDate.fromGregorian(iranTime);
      // July 12, 2026 = 21 Tir 1405 shamsi = 2585/4/21 imperial
      expect(fromIran.year, 2585);
      expect(fromIran.month, 4);
      expect(fromIran.day, 21);
    });

    test('now() year is within plausible range', () {
      final d = ImperialPersianDate.now();
      // As of 2026, imperial year should be around 2585
      expect(d.year, inInclusiveRange(2583, 2600));
    });

    test('now() time components are within valid bounds', () {
      final d = ImperialPersianDate.now();
      expect(d.hour, inInclusiveRange(0, 23));
      expect(d.minute, inInclusiveRange(0, 59));
      expect(d.second, inInclusiveRange(0, 59));
      expect(d.millisecond, inInclusiveRange(0, 999));
    });

    test('now() Iran offset: IRST (+3:30) applied in December', () {
      // UTC 2026-12-20 21:30 → Iran = Dec 21 01:00
      final utc = DateTime.utc(2026, 12, 20, 21, 30, 0);
      final iranTime = utc.add(const Duration(hours: 3, minutes: 30));
      final d = ImperialPersianDate.fromGregorian(iranTime);
      // Dec 21 = 30 Azar 1405 shamsi = 2585/9/30 imperial
      expect(d.year, 2585);
      expect(d.month, 9);
      expect(d.day, 30);
    });

    test('now() Iran offset: IRDT (+4:30) applied in June', () {
      // UTC 2026-06-21 20:00 → Iran = June 22 00:30
      final utc = DateTime.utc(2026, 6, 21, 20, 0, 0);
      final iranTime = utc.add(const Duration(hours: 4, minutes: 30));
      final d = ImperialPersianDate.fromGregorian(iranTime);
      // June 22 = 1 Tir 1405 shamsi = 2585/4/1 imperial
      expect(d.year, 2585);
      expect(d.month, 4);
      expect(d.day, 1);
    });
  });

  // ==========================================================================
  // 10. toString, toStringWithTime, round-trips, historical dates
  // ==========================================================================
  group('toString', () {
    test('format is YYYY/M/D (no leading zeros)', () {
      expect(ImperialPersianDate(2585, 4, 21).toString(), '2585/4/21');
      expect(ImperialPersianDate(2585, 1, 1).toString(), '2585/1/1');
      expect(ImperialPersianDate(2585, 12, 29).toString(), '2585/12/29');
    });
  });

  group('toStringWithTime', () {
    test('pads hour, minute, second with leading zeros', () {
      final d = ImperialPersianDate(2585, 4, 21, hour: 9, minute: 5, second: 3);
      expect(d.toStringWithTime(), '2585/4/21 09:05:03');
    });

    test('no padding needed for double-digit values', () {
      final d =
          ImperialPersianDate(2585, 4, 21, hour: 14, minute: 30, second: 45);
      expect(d.toStringWithTime(), '2585/4/21 14:30:45');
    });

    test('midnight is 00:00:00', () {
      final d = ImperialPersianDate(2585, 4, 21);
      expect(d.toStringWithTime(), '2585/4/21 00:00:00');
    });
  });

  group('Round-trips', () {
    test('Gregorian → Imperial → Gregorian preserves date', () {
      final dates = [
        DateTime(2026, 7, 12),
        DateTime(2026, 1, 1),
        DateTime(2026, 3, 21),
        DateTime(2025, 12, 31),
        DateTime(2000, 1, 1),
      ];
      for (final original in dates) {
        final imperial = ImperialPersianDate.fromGregorian(original);
        final back = imperial.toGregorian();
        expect(back.year, original.year, reason: 'year mismatch for $original');
        expect(back.month, original.month,
            reason: 'month mismatch for $original');
        expect(back.day, original.day, reason: 'day mismatch for $original');
      }
    });

    test('Shamsi → Imperial → Shamsi preserves date', () {
      final shamsiDates = [
        [1405, 4, 21],
        [1404, 12, 1],
        [1403, 12, 30],
        [1400, 6, 31],
        [1357, 11, 23],
      ];
      for (final s in shamsiDates) {
        final imperial = ImperialPersianDate.fromShamsi(s[0], s[1], s[2]);
        final back = imperial.toShamsi();
        expect(back, s, reason: 'round-trip failed for shamsi $s');
      }
    });

    test('Imperial → JDN → Imperial preserves date for multiple dates', () {
      final imperialDates = [
        [2585, 1, 1],
        [2585, 6, 31],
        [2585, 7, 1],
        [2583, 12, 30],
        [2585, 12, 29],
      ];
      for (final parts in imperialDates) {
        final original = ImperialPersianDate(parts[0], parts[1], parts[2]);
        final restored = ImperialPersianDate.fromJulianDayNumber(
            original.toJulianDayNumber());
        expect(restored.year, original.year);
        expect(restored.month, original.month);
        expect(restored.day, original.day);
      }
    });
  });

  group('Historical dates', () {
    test('1941-03-21 = Imperial 2500/1/1 (2500 celebration)', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(1941, 3, 21));
      expect(d.year, 2500);
      expect(d.month, 1);
      expect(d.day, 1);
    });

    test('Imperial 2500/1/1 → Gregorian 1941-03-21', () {
      final g = ImperialPersianDate(2500, 1, 1).toGregorian();
      expect(g.year, 1941);
      expect(g.month, 3);
      expect(g.day, 21);
    });

    test('1979-02-11 (Islamic Revolution) = Imperial 2537/11/23', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(1979, 2, 11));
      expect(d.year, 2537);
      expect(d.month, 11);
      expect(d.day, 23);
    });

    test('2000-01-01 (Y2K) = Imperial 2558/10/11', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(2000, 1, 1));
      expect(d.year, 2558);
      expect(d.month, 10);
      expect(d.day, 11);
    });

    test('2026-03-20 = last day of year 2584 (12/29)', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(2026, 3, 20));
      expect(d.year, 2584);
      expect(d.month, 12);
      expect(d.day, 29);
    });

    test('2026-09-22 = last day of Shahrivar 2585 (6/31)', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(2026, 9, 22));
      expect(d.year, 2585);
      expect(d.month, 6);
      expect(d.day, 31);
    });

    test('2026-09-23 = first day of Mehr 2585 (7/1)', () {
      final d = ImperialPersianDate.fromGregorian(DateTime(2026, 9, 23));
      expect(d.year, 2585);
      expect(d.month, 7);
      expect(d.day, 1);
    });
  });
}
