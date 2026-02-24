# Imperial Persian Date

A comprehensive Flutter package for working with the Imperial Persian (Shahanshahi) calendar system. This package provides seamless conversion between Gregorian, Solar Hijri (Shamsi), and Imperial Persian calendars with full date manipulation capabilities.

## About the Imperial Persian Calendar

The Imperial Persian calendar (گاه‌شماری شاهنشاهی) was officially adopted on March 14, 1976 (24 Esfand 1354 Shamsi) following a joint session of the Iranian Parliament. It uses the same solar calendar structure as the Shamsi calendar but with a different epoch:

- **Year 1 Imperial** = 559 BCE (Coronation of Cyrus the Great)
- **Conversion Formula**: Imperial Year = Shamsi Year + 1180
- **Year 2500 Imperial** = 1942 CE (Beginning of Mohammad Reza Pahlavi's reign)

## Features

✅ Convert between Gregorian, Shamsi, and Imperial Persian calendars  
✅ Full date arithmetic (add/subtract years, months, days)  
✅ Comprehensive date formatting with Persian and English names  
✅ Leap year calculations  
✅ Date comparison operations  
✅ Weekday and month name localization (Farsi & English)  
✅ Julian Day Number support  
✅ Immutable date objects  
✅ Null-safe implementation  

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  imperial_persian_date: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:imperial_persian_date/imperial_persian_date.dart';

// Get current date in Imperial Persian calendar
final today = ImperialPersianDate.now();
print(today); // e.g., 2584/12/5

// Create a specific date
final date = ImperialPersianDate(2584, 12, 5);
print(date.format('WWWW DD MMMM YYYY')); // سه‌شنبه 05 اسفند 2584
```

### Converting from Gregorian

```dart
// Convert from DateTime
final gregorianDate = DateTime(2026, 2, 24);
final imperialDate = ImperialPersianDate.fromGregorian(gregorianDate);
print(imperialDate); // 2584/12/5

// Convert back to Gregorian
final backToGregorian = imperialDate.toGregorian();
print(backToGregorian); // 2026-02-24 00:00:00.000
```

### Converting from Shamsi (Solar Hijri)

```dart
// Convert from Shamsi date
final fromShamsi = ImperialPersianDate.fromShamsi(1404, 12, 5);
print(fromShamsi.year); // 2584 (1404 + 1180)

// Convert to Shamsi
final shamsiDate = imperialDate.toShamsi();
print(shamsiDate); // [1404, 12, 5]
```

### Date Formatting

The package supports extensive formatting options:

```dart
final date = ImperialPersianDate(2584, 12, 5, hour: 14, minute: 30);

// Standard formats
print(date.format('YYYY/MM/DD')); // 2584/12/05
print(date.format('YYYY-MM-DD')); // 2584-12-05

// Full Persian format
print(date.format('WWWW DD MMMM YYYY')); // سه‌شنبه 05 اسفند 2584

// English format
print(date.format('WWWE DD MMME YYYY')); // Seshanbe 05 Esfand 2584

// With time
print(date.format('YYYY/MM/DD HH:mm:ss')); // 2584/12/05 14:30:00

// Custom formats
print(date.format('D MMMM YY')); // 5 اسفند 84
print(date.format('WWWW، D MMMM YYYY')); // سه‌شنبه، 5 اسفند 2584
```

#### Format Patterns

| Pattern | Description | Example |
|---------|-------------|---------|
| `YYYY` | 4-digit year | 2604 |
| `YY` | 2-digit year | 04 |
| `MMMM` | Full month name (Farsi) | بهمن |
| `MMME` | Full month name (English) | Bahman |
| `MMM` | Abbreviated month (Farsi) | بهم |
| `MM` | 2-digit month | 12 |
| `M` | Month without leading zero | 12 |
| `DD` | 2-digit day | 06 |
| `D` | Day without leading zero | 6 |
| `WWWW` | Full weekday (Farsi) | جمعه |
| `WWWE` | Full weekday (English) | Jomeh |
| `WWW` | Abbreviated weekday (Farsi) | جمع |
| `HH` | 2-digit hour (24h) | 14 |
| `H` | Hour without leading zero | 14 |
| `mm` | 2-digit minute | 30 |
| `m` | Minute without leading zero | 30 |
| `ss` | 2-digit second | 05 |
| `s` | Second without leading zero | 5 |

### Date Arithmetic

```dart
final date = ImperialPersianDate(2584, 12, 5);

// Add/subtract years
final nextYear = date.addYears(1);
print(nextYear); // 2585/12/5

final lastYear = date.addYears(-1);
print(lastYear); // 2583/12/5

// Add/subtract months
final nextMonth = date.addMonths(1);
print(nextMonth); // 2585/1/5

final lastMonth = date.addMonths(-1);
print(lastMonth); // 2584/11/5

// Add/subtract days
final tomorrow = date.addDays(1);
print(tomorrow); // 2584/12/6

final yesterday = date.addDays(-1);
print(yesterday); // 2584/12/4

// Calculate difference in days
final epoch = ImperialPersianDate(2500, 1, 1);
final diffDays = date.difference(epoch);
print('Days since epoch: $diffDays');
```

### Date Comparison

```dart
final date1 = ImperialPersianDate(2584, 12, 5);
final date2 = ImperialPersianDate(2585, 1, 1);

// Comparison operators
print(date1.isBefore(date2)); // true
print(date1.isAfter(date2)); // false
print(date1.isAtSameMomentAs(date2)); // false

// Comparable interface
print(date1.compareTo(date2)); // -1 (negative means before)

// Equality
print(date1 == date2); // false
```

### Date Properties

```dart
final date = ImperialPersianDate(2584, 12, 5);

// Basic properties
print(date.year); // 2584
print(date.month); // 12
print(date.day); // 5

// Weekday (0 = Saturday, 6 = Friday)
print(date.weekDay); // 2 (Tuesday)
print(date.weekDayName); // سه‌شنبه
print(date.weekDayNameEn); // Seshanbe

// Month names
print(date.monthName); // اسفند
print(date.monthNameEn); // Esfand

// Month length
print(date.monthLength); // 29 or 30 (depending on leap year)

// Leap year check
print(date.isLeapYear()); // true or false
```

### Copying with Modifications

```dart
final date = ImperialPersianDate(2584, 12, 5, hour: 10, minute: 30);

// Create a copy with modified fields
final modified = date.copyWith(
  day: 15,
  hour: 14,
  minute: 45,
);
print(modified); // 2584/12/15
print(modified.format('HH:mm')); // 14:45
```

### Julian Day Number

```dart
final date = ImperialPersianDate(2584, 12, 5);

// Convert to Julian Day Number
final jdn = date.toJulianDayNumber();
print(jdn); // e.g., 2461097

// Create from Julian Day Number
final fromJdn = ImperialPersianDate.fromJulianDayNumber(jdn);
print(fromJdn); // 2584/12/5
```

## Month Names

### Persian (Farsi)
1. فروردین (Farvardin)
2. اردیبهشت (Ordibehesht)
3. خرداد (Khordad)
4. تیر (Tir)
5. مرداد (Mordad)
6. شهریور (Shahrivar)
7. مهر (Mehr)
8. آبان (Aban)
9. آذر (Azar)
10. دی (Dey)
11. بهمن (Bahman)
12. اسفند (Esfand)

### Weekday Names

#### Persian (Farsi)
- شنبه (Shanbe) - Saturday
- یکشنبه (Yekshanbe) - Sunday
- دوشنبه (Doshanbe) - Monday
- سه‌شنبه (Seshanbe) - Tuesday
- چهارشنبه (Chaharshanbe) - Wednesday
- پنج‌شنبه (Panjshanbe) - Thursday
- جمعه (Jomeh) - Friday

## Calendar Conversion Examples

```dart
// Historical date: Iranian Revolution (11 February 1979)
final revolution = ImperialPersianDate.fromGregorian(DateTime(1979, 2, 11));
print(revolution); // 2537/11/22
print(revolution.format('DD MMMM YYYY')); // 22 بهمن 2537

// Epoch: Year 2500 celebration (1971)
final epoch2500 = ImperialPersianDate(2500, 1, 1);
final gregorian = epoch2500.toGregorian();
print(gregorian); // 1941-03-21 (approximately)

// Today's date example (24 February 2026)
final today = ImperialPersianDate.fromGregorian(DateTime(2026, 2, 24));
print(today); // 2584/12/5
print(today.format('WWWW DD MMMM YYYY')); // سه‌شنبه 05 اسفند 2584

// Round-trip conversion
final shamsi = today.toShamsi();
final backToImperial = ImperialPersianDate.fromShamsi(shamsi[0], shamsi[1], shamsi[2]);
print(today == backToImperial); // true
```

## Leap Year Algorithm

The package uses the accurate 33-year cycle algorithm for Persian calendar leap year calculations. A year is a leap year if it follows the traditional Persian astronomical rules.

```dart
final date = ImperialPersianDate(2584, 12, 30); // Leap year (1404 Shamsi is leap)
print(date.isLeapYear()); // true
print(date.monthLength); // 30 (Esfand has 30 days in leap years)

final normalYear = ImperialPersianDate(2585, 12, 29);
print(normalYear.isLeapYear()); // false
print(normalYear.monthLength); // 29 (Esfand has 29 days normally)
```

## API Reference

### Constructors

- `ImperialPersianDate(int year, int month, int day, {int hour, int minute, int second, int millisecond})` - Creates a date
- `ImperialPersianDate.now()` - Current date and time
- `ImperialPersianDate.fromGregorian(DateTime dateTime)` - From Gregorian calendar
- `ImperialPersianDate.fromShamsi(int year, int month, int day, {...})` - From Shamsi calendar
- `ImperialPersianDate.fromJulianDayNumber(int jdn, {...})` - From Julian Day Number

### Properties

- `year`, `month`, `day` - Date components
- `hour`, `minute`, `second`, `millisecond` - Time components
- `weekDay` - Day of week (0-6)
- `weekDayName`, `weekDayNameEn` - Weekday names
- `monthName`, `monthNameEn` - Month names
- `monthLength` - Days in current month

### Methods

- `toGregorian()` - Convert to DateTime
- `toShamsi()` - Convert to Shamsi date
- `toJulianDayNumber()` - Convert to JDN
- `format(String pattern)` - Format date
- `addYears(int years)` - Add years
- `addMonths(int months)` - Add months
- `addDays(int days)` - Add days
- `difference(ImperialPersianDate other)` - Days difference
- `isBefore(ImperialPersianDate other)` - Before comparison
- `isAfter(ImperialPersianDate other)` - After comparison
- `isAtSameMomentAs(ImperialPersianDate other)` - Equality check
- `isLeapYear()` - Leap year check
- `copyWith({...})` - Create modified copy
- `compareTo(ImperialPersianDate other)` - Comparable implementation

### Constants

- `ImperialPersianDate.imperialOffset` - Offset value (1180)

## Comparison with Shamsi Date Package

This package is inspired by and maintains API compatibility with the excellent [shamsi_date](https://github.com/FatulM/shamsi_date) package. All features available in shamsi_date are available here for the Imperial Persian calendar:

- ✅ Same API design and method names
- ✅ Same formatting patterns
- ✅ Same date arithmetic operations
- ✅ Same conversion capabilities
- ✅ Additional Imperial ↔ Shamsi conversion

## Example App

Check out the [example](example/) directory for a complete Flutter application demonstrating all features of this package.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- Inspired by [shamsi_date](https://github.com/FatulM/shamsi_date) by FatulM
- Persian calendar algorithms based on astronomical calculations
- Historical information about the Imperial Persian calendar

## Support

If you find this package useful, please give it a ⭐ on GitHub!

For issues, feature requests, or questions, please visit the [GitHub repository](https://github.com/SwanFlutter/imperial_persian_date).
