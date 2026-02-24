import 'package:flutter_test/flutter_test.dart';
import 'package:imperial_persian_date/imperial_persian_date.dart';

void main() {
  group('ImperialPersianDate', () {
    test('creates a valid date', () {
      final date = ImperialPersianDate(2604, 12, 6);
      expect(date.year, 2604);
      expect(date.month, 12);
      expect(date.day, 6);
    });

    test('throws error for invalid date', () {
      expect(() => ImperialPersianDate(2604, 13, 1), throwsArgumentError);
      expect(() => ImperialPersianDate(2604, 12, 32), throwsArgumentError);
      expect(() => ImperialPersianDate(2604, 0, 1), throwsArgumentError);
    });

    test('converts from Gregorian correctly', () {
      final gregorian = DateTime(2026, 2, 24);
      final imperial = ImperialPersianDate.fromGregorian(gregorian);

      // 2026-02-24 should be 1404/12/5 Shamsi = 2584/12/5 Imperial
      expect(imperial.year, 2584);
      expect(imperial.month, 12);
      expect(imperial.day, 5);
    });

    test('converts to Gregorian correctly', () {
      final imperial = ImperialPersianDate(2584, 12, 5);
      final gregorian = imperial.toGregorian();

      expect(gregorian.year, 2026);
      expect(gregorian.month, 2);
      expect(gregorian.day, 24);
    });

    test('converts from Shamsi correctly', () {
      final imperial = ImperialPersianDate.fromShamsi(1404, 12, 5);

      expect(imperial.year, 2584);
      expect(imperial.month, 12);
      expect(imperial.day, 5);
    });

    test('converts to Shamsi correctly', () {
      final imperial = ImperialPersianDate(2584, 12, 5);
      final shamsi = imperial.toShamsi();

      expect(shamsi[0], 1404);
      expect(shamsi[1], 12);
      expect(shamsi[2], 5);
    });

    test('imperial offset is correct', () {
      expect(ImperialPersianDate.imperialOffset, 1180);
    });

    test('formats date correctly', () {
      final date = ImperialPersianDate(2604, 12, 6);

      expect(date.format('YYYY/MM/DD'), '2604/12/06');
      expect(date.format('YYYY-MM-DD'), '2604-12-06');
      expect(date.format('D/M/YYYY'), '6/12/2604');
    });

    test('formats with month names', () {
      final date = ImperialPersianDate(2604, 12, 6);

      expect(date.format('MMMM'), 'اسفند');
      expect(date.format('MMME'), 'Esfand');
      expect(date.monthName, 'اسفند');
      expect(date.monthNameEn, 'Esfand');
    });

    test('formats with weekday names', () {
      final date = ImperialPersianDate(2604, 12, 6);

      expect(date.weekDayName, isNotEmpty);
      expect(date.weekDayNameEn, isNotEmpty);
    });

    test('adds years correctly', () {
      final date = ImperialPersianDate(2604, 12, 6);
      final nextYear = date.addYears(1);

      expect(nextYear.year, 2605);
      expect(nextYear.month, 12);
      expect(nextYear.day, 6);
    });

    test('adds months correctly', () {
      final date = ImperialPersianDate(2604, 12, 6);
      final nextMonth = date.addMonths(1);

      expect(nextMonth.year, 2605);
      expect(nextMonth.month, 1);
      expect(nextMonth.day, 6);
    });

    test('adds days correctly', () {
      final date = ImperialPersianDate(2604, 12, 6);
      final tomorrow = date.addDays(1);

      expect(tomorrow.day, 7);
    });

    test('calculates difference correctly', () {
      final date1 = ImperialPersianDate(2604, 12, 6);
      final date2 = ImperialPersianDate(2604, 12, 10);

      expect(date2.difference(date1), 4);
      expect(date1.difference(date2), -4);
    });

    test('compares dates correctly', () {
      final date1 = ImperialPersianDate(2604, 12, 6);
      final date2 = ImperialPersianDate(2605, 1, 1);

      expect(date1.isBefore(date2), true);
      expect(date2.isAfter(date1), true);
      expect(date1.isAtSameMomentAs(date1), true);
    });

    test('checks equality correctly', () {
      final date1 = ImperialPersianDate(2604, 12, 6);
      final date2 = ImperialPersianDate(2604, 12, 6);
      final date3 = ImperialPersianDate(2604, 12, 7);

      expect(date1 == date2, true);
      expect(date1 == date3, false);
    });

    test('copyWith works correctly', () {
      final date = ImperialPersianDate(2604, 12, 6, hour: 10, minute: 30);
      final modified = date.copyWith(day: 15, hour: 14);

      expect(modified.year, 2604);
      expect(modified.month, 12);
      expect(modified.day, 15);
      expect(modified.hour, 14);
      expect(modified.minute, 30);
    });

    test('detects leap years correctly', () {
      // Test known leap years in Shamsi calendar
      // 1403 Shamsi is a leap year, so 2583 Imperial should be leap
      final leapYear = ImperialPersianDate(2583, 1, 1);
      expect(leapYear.isLeapYear(), true);
      expect(leapYear.copyWith(month: 12).monthLength, 30);
    });

    test('month length is correct', () {
      final date = ImperialPersianDate(2604, 1, 1);

      // First 6 months have 31 days
      for (int month = 1; month <= 6; month++) {
        expect(date.copyWith(month: month).monthLength, 31);
      }

      // Months 7-11 have 30 days
      for (int month = 7; month <= 11; month++) {
        expect(date.copyWith(month: month).monthLength, 30);
      }

      // Month 12 has 29 or 30 days depending on leap year
      final month12 = date.copyWith(month: 12);
      expect(month12.monthLength, anyOf(29, 30));
    });

    test('toString works correctly', () {
      final date = ImperialPersianDate(2604, 12, 6);
      expect(date.toString(), '2604/12/6');
    });

    test('toStringWithTime works correctly', () {
      final date =
          ImperialPersianDate(2604, 12, 6, hour: 14, minute: 30, second: 45);
      expect(date.toStringWithTime(), '2604/12/6 14:30:45');
    });

    test('Julian Day Number conversion works', () {
      final date = ImperialPersianDate(2604, 12, 6);
      final jdn = date.toJulianDayNumber();
      final fromJdn = ImperialPersianDate.fromJulianDayNumber(jdn);

      expect(fromJdn.year, date.year);
      expect(fromJdn.month, date.month);
      expect(fromJdn.day, date.day);
    });

    test('round-trip Gregorian conversion', () {
      final original = DateTime(2026, 2, 24);
      final imperial = ImperialPersianDate.fromGregorian(original);
      final backToGregorian = imperial.toGregorian();

      expect(backToGregorian.year, original.year);
      expect(backToGregorian.month, original.month);
      expect(backToGregorian.day, original.day);
    });

    test('round-trip Shamsi conversion', () {
      final imperial = ImperialPersianDate(2584, 12, 5);
      final shamsi = imperial.toShamsi();
      final backToImperial =
          ImperialPersianDate.fromShamsi(shamsi[0], shamsi[1], shamsi[2]);

      expect(backToImperial, imperial);
    });

    test('historical date: Year 2500 celebration', () {
      // Year 2500 Imperial = 1320 Shamsi = 1941 CE (approximately)
      final epoch2500 = ImperialPersianDate(2500, 1, 1);
      final gregorian = epoch2500.toGregorian();

      // Should be around March 1941
      expect(gregorian.year, 1941);
      expect(gregorian.month, 3);
    });

    test('format with time components', () {
      final date =
          ImperialPersianDate(2604, 12, 6, hour: 14, minute: 30, second: 45);

      expect(date.format('HH:mm:ss'), '14:30:45');
      expect(date.format('H:m:s'), '14:30:45');
      expect(date.format('YYYY/MM/DD HH:mm'), '2604/12/06 14:30');
    });
  });
}
