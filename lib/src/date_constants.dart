/// Constants used in Imperial Persian calendar calculations and formatting.
library;

/// Offset between Imperial Persian and Shamsi (Solar Hijri) calendars.
/// Imperial Year = Shamsi Year + 1180
const int imperialOffset = 1180;

/// Persian month names in Farsi.
const List<String> persianMonthNames = [
  'فروردین', // Farvardin
  'اردیبهشت', // Ordibehesht
  'خرداد', // Khordad
  'تیر', // Tir
  'مرداد', // Mordad
  'شهریور', // Shahrivar
  'مهر', // Mehr
  'آبان', // Aban
  'آذر', // Azar
  'دی', // Dey
  'بهمن', // Bahman
  'اسفند', // Esfand
];

/// Persian month names in English.
const List<String> persianMonthNamesEn = [
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

/// Persian weekday names in Farsi.
const List<String> persianWeekDayNames = [
  'شنبه', // Shanbe (Saturday)
  'یکشنبه', // Yekshanbe (Sunday)
  'دوشنبه', // Doshanbe (Monday)
  'سه‌شنبه', // Seshanbe (Tuesday)
  'چهارشنبه', // Chaharshanbe (Wednesday)
  'پنج‌شنبه', // Panjshanbe (Thursday)
  'جمعه', // Jomeh (Friday)
];

/// Persian weekday names in English.
const List<String> persianWeekDayNamesEn = [
  'Shanbe',
  'Yekshanbe',
  'Doshanbe',
  'Seshanbe',
  'Chaharshanbe',
  'Panjshanbe',
  'Jomeh',
];

/// Number of days in each month (non-leap year).
const List<int> monthDays = [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];

/// Number of days in each month (leap year).
const List<int> monthDaysLeap = [
  31,
  31,
  31,
  31,
  31,
  31,
  30,
  30,
  30,
  30,
  30,
  30
];
