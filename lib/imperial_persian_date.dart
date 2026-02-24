/// Imperial Persian (Shahanshahi) calendar package.
///
/// The Imperial Persian calendar (گاه‌شماری شاهنشاهی) was officially adopted
/// on March 14, 1976 (24 Esfand 1354 Shamsi). It uses the same solar calendar
/// structure as the Shamsi calendar but with a different epoch:
/// - Year 1 Imperial = 559 BCE (Coronation of Cyrus the Great)
/// - Imperial Year = Shamsi Year + 1180
///
/// This package provides comprehensive date conversion and manipulation
/// between Gregorian, Shamsi (Solar Hijri), and Imperial Persian calendars.
///
/// Example:
/// ```dart
/// // Get current date in Imperial Persian calendar
/// final today = ImperialPersianDate.now();
/// print(today.format('WWWW DD MMMM YYYY')); // e.g., "سه‌شنبه 05 اسفند 2584"
///
/// // Convert from Gregorian
/// final date = ImperialPersianDate.fromGregorian(DateTime(2026, 2, 24));
/// print(date); // 2584/12/5
///
/// // Convert from Shamsi
/// final fromShamsi = ImperialPersianDate.fromShamsi(1404, 12, 5);
/// print(fromShamsi.year); // 2584
///
/// // Date arithmetic
/// final nextMonth = today.addMonths(1);
/// final lastYear = today.addYears(-1);
/// final difference = today.difference(date);
/// ```
library;

export 'src/date_constants.dart';
export 'src/imperial_persian_date_base.dart';
export 'src/imperial_persian_formatter.dart';
