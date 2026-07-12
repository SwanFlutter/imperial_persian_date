
## 0.0.3

* Fix `ImperialPersianDate.now()` returning wrong date on devices with non-Iran timezone
* `now()` now uses Iran Standard Time (IRST UTC+3:30 / IRDT UTC+4:30) internally to ensure the correct Persian date regardless of device timezone

---

## 0.0.2


* Fix pub point


---

## 0.0.1

* Initial release of Imperial Persian Date package
* Complete implementation of Imperial Persian (Shahanshahi) calendar system
* Seamless conversion between Gregorian, Shamsi (Solar Hijri), and Imperial Persian calendars
* Comprehensive date formatting with customizable patterns
* Full support for Persian and English month/weekday names
* Date arithmetic operations: addYears, addMonths, addDays
* Date comparison methods: isBefore, isAfter, isAtSameMomentAs
* Accurate leap year calculations using 33-year cycle algorithm
* Julian Day Number support for astronomical calculations
* Immutable date objects with copyWith functionality
* Null-safe implementation
* API compatibility with shamsi_date package
* Complete example application demonstrating all features
* Comprehensive documentation in English

