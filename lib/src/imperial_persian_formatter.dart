/// Formatter for Imperial Persian dates.
library;

import 'imperial_persian_date_base.dart';

/// Provides formatting functionality for Imperial Persian dates.
class ImperialPersianFormatter {
  /// Formats an Imperial Persian date according to the given pattern.
  ///
  /// Supported patterns:
  /// - YYYY: 4-digit year (e.g., 2604)
  /// - YY: 2-digit year (e.g., 04)
  /// - MMMM: Full month name in Farsi (e.g., بهمن)
  /// - MMME: Full month name in English (e.g., Bahman)
  /// - MMM: Abbreviated month name in Farsi (first 3 chars)
  /// - MM: 2-digit month (e.g., 12)
  /// - M: Month without leading zero (e.g., 12)
  /// - DD: 2-digit day (e.g., 06)
  /// - D: Day without leading zero (e.g., 6)
  /// - WWWW: Full weekday name in Farsi (e.g., جمعه)
  /// - WWWE: Full weekday name in English (e.g., Friday)
  /// - WWW: Abbreviated weekday name in Farsi (first 3 chars)
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
  /// print(ImperialPersianFormatter.format(date, 'YYYY/MM/DD')); // 2584/12/05
  /// print(ImperialPersianFormatter.format(date, 'WWWW DD MMMM YYYY')); // سه‌شنبه 05 اسفند 2584
  /// ```
  static String format(ImperialPersianDate date, String pattern) {
    final buffer = StringBuffer();
    int i = 0;

    while (i < pattern.length) {
      // Year patterns
      if (_matchesAt(pattern, i, 'YYYY')) {
        buffer.write(date.year.toString());
        i += 4;
      } else if (_matchesAt(pattern, i, 'YY')) {
        buffer.write((date.year % 100).toString().padLeft(2, '0'));
        i += 2;
      }
      // Month patterns (check longer patterns first)
      else if (_matchesAt(pattern, i, 'MMME')) {
        buffer.write(date.monthNameEn);
        i += 4;
      } else if (_matchesAt(pattern, i, 'MMMM')) {
        buffer.write(date.monthName);
        i += 4;
      } else if (_matchesAt(pattern, i, 'MMM')) {
        buffer.write(_abbreviate(date.monthName, 3));
        i += 3;
      } else if (_matchesAt(pattern, i, 'MM')) {
        buffer.write(date.month.toString().padLeft(2, '0'));
        i += 2;
      } else if (_matchesAt(pattern, i, 'M')) {
        buffer.write(date.month.toString());
        i += 1;
      }
      // Day patterns
      else if (_matchesAt(pattern, i, 'DD')) {
        buffer.write(date.day.toString().padLeft(2, '0'));
        i += 2;
      } else if (_matchesAt(pattern, i, 'D')) {
        buffer.write(date.day.toString());
        i += 1;
      }
      // Weekday patterns
      else if (_matchesAt(pattern, i, 'WWWE')) {
        buffer.write(date.weekDayNameEn);
        i += 4;
      } else if (_matchesAt(pattern, i, 'WWWW')) {
        buffer.write(date.weekDayName);
        i += 4;
      } else if (_matchesAt(pattern, i, 'WWW')) {
        buffer.write(_abbreviate(date.weekDayName, 3));
        i += 3;
      }
      // Hour patterns
      else if (_matchesAt(pattern, i, 'HH')) {
        buffer.write(date.hour.toString().padLeft(2, '0'));
        i += 2;
      } else if (_matchesAt(pattern, i, 'H')) {
        buffer.write(date.hour.toString());
        i += 1;
      }
      // Minute patterns
      else if (_matchesAt(pattern, i, 'mm')) {
        buffer.write(date.minute.toString().padLeft(2, '0'));
        i += 2;
      } else if (_matchesAt(pattern, i, 'm')) {
        buffer.write(date.minute.toString());
        i += 1;
      }
      // Second patterns
      else if (_matchesAt(pattern, i, 'ss')) {
        buffer.write(date.second.toString().padLeft(2, '0'));
        i += 2;
      } else if (_matchesAt(pattern, i, 's')) {
        buffer.write(date.second.toString());
        i += 1;
      }
      // No match, just copy the character
      else {
        buffer.write(pattern[i]);
        i += 1;
      }
    }

    return buffer.toString();
  }

  /// Checks if the pattern matches at the given position.
  static bool _matchesAt(String text, int position, String pattern) {
    if (position + pattern.length > text.length) return false;
    return text.substring(position, position + pattern.length) == pattern;
  }

  /// Abbreviates a string to the specified length.
  static String _abbreviate(String text, int length) {
    if (text.length <= length) return text;
    return text.substring(0, length);
  }
}
