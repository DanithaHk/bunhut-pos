import '../enums/date_filter.dart';

class AppDateUtils {
  AppDateUtils._();

  /// ---------------- TODAY ----------------

  static DateTime todayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime todayEnd() {
    return todayStart().add(const Duration(days: 1));
  }

  /// ---------------- THIS WEEK ----------------
  /// Monday -> Sunday

  static DateTime weekStart() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(start.year, start.month, start.day);
  }

  static DateTime weekEnd() {
    return weekStart().add(const Duration(days: 7));
  }

  /// ---------------- THIS MONTH ----------------

  static DateTime monthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime monthEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 1);
  }

  /// ---------------- LAST MONTH ----------------

  static DateTime lastMonthStart() {
    final now = DateTime.now();

    if (now.month == 1) {
      return DateTime(now.year - 1, 12, 1);
    }

    return DateTime(now.year, now.month - 1, 1);
  }

  static DateTime lastMonthEnd() {
    final start = lastMonthStart();
    return DateTime(start.year, start.month + 1, 1);
  }

  /// ---------------- THIS YEAR ----------------

  static DateTime yearStart() {
    final now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }

  static DateTime yearEnd() {
    final now = DateTime.now();
    return DateTime(now.year + 1, 1, 1);
  }

  /// ---------------- CUSTOM ----------------

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day + 1);
  }

  /// ---------------- RANGE ----------------

  static Map<String, DateTime> getRange(DateFilter filter,
      {DateTime? startDate, DateTime? endDate}) {
    switch (filter) {
      case DateFilter.today:
        return {
          'start': todayStart(),
          'end': todayEnd(),
        };

      case DateFilter.thisWeek:
        return {
          'start': weekStart(),
          'end': weekEnd(),
        };

      case DateFilter.thisMonth:
        return {
          'start': monthStart(),
          'end': monthEnd(),
        };

      case DateFilter.lastMonth:
        return {
          'start': lastMonthStart(),
          'end': lastMonthEnd(),
        };

      case DateFilter.thisYear:
        return {
          'start': yearStart(),
          'end': yearEnd(),
        };

      case DateFilter.custom:
        return {
          'start': startOfDay(startDate!),
          'end': endOfDay(endDate!),
        };
    }
  }
}