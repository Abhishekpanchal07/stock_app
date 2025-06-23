import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../modals/benchmark_model.dart';
import '../modals/time_series_model.dart';
import '../repository/time_series_api_service.dart';

class StockDetailViewmodel extends ChangeNotifier {
  TimeSeriesModel? stockDetail;
  BenchmarkModel? benchmark;

  bool _showProgressLoader = false;
  bool get showProgressLoader => _showProgressLoader;

  final timeSeriesApiService = TimeSeriesApiService();

  String _selectedRange = '6M';
  String get selectedRange => _selectedRange;
  set updateSelectedRangeToDefault(String range) {
    _selectedRange = range;
  }

  static const double usdToInrRate = 83.0;

  void updateSelectedRange(String range) {
    if (_selectedRange != range) {
      _selectedRange = range;
      notifyListeners();
    }
  }

  Future<void> fetchStockDetail({required String stockSymbol}) async {
    _setLoading(true);
    try {
      stockDetail =
          await timeSeriesApiService.fetchStockDetail(stockSymbol: stockSymbol);
    } catch (e) {
      log("Error fetching stock: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchBenchmarkDetail() async {
    _setLoading(true);
    try {
      benchmark = await timeSeriesApiService.fetchBenchmarkDetail();
    } catch (e) {
      log("Error fetching benchmark: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _showProgressLoader = value;
    notifyListeners();
  }

  /// ==== Filtered Data Accessors ====
  List<FlSpot> get filteredStockSpots =>
      _toSpots(_filterValues(stockDetail?.values ?? []));
  List<FlSpot> get filteredBenchmarkSpots =>
      _toSpots(_filterValues(benchmark?.values ?? []));
  /*  List<DateTime> get filteredDates => _filterValues(stockDetail?.values ?? [])
      .map((e) => DateTime.tryParse(e.datetime ?? '') ?? DateTime.now())
      .toList(); */
  List<DateTime> get filteredDates => _filterValues(stockDetail?.values ?? [])
      .map((e) => DateTime.tryParse(e.datetime ?? '') ?? DateTime.now())
      .toList();

  double get stockReturnPercent {
    final spots = filteredStockSpots;
    if (spots.length < 2) return 0;
    final first = spots.firstWhere((s) => s.y > 0, orElse: () => spots.first);
    final last = spots.lastWhere((s) => s.y > 0, orElse: () => spots.last);
    return ((last.y - first.y) / first.y) * 100;
  }

  /// ==== Helpers ====
  /*  List<dynamic> _filterValues(List<dynamic> allValues) {
    switch (_selectedRange) {
      case '1W': return _getLastNDays(allValues, 7);
      case '3W': return _getWeeklyData(allValues, 3);
      case '1M': return _getWeeklyData(allValues, 4);
      case '3M':
      case '6M': return _getMonthlyData(allValues, 6);
      case '1Y': return _getYearlyData(allValues, 2, 1);
      case '5Y': return _getYearlyData(allValues, 2, 5);
      case 'MAX': return _getMaxRangeData(allValues);
      default: return _getMonthlyData(allValues, 6);
    }
  } */

  // Updated _filterValues method in StockDetailViewmodel
  List<dynamic> _filterValues(List<dynamic> allValues) {
    switch (_selectedRange) {
      case '1W':
        return _getLastNDays(allValues, 7);
      case '3W':
        return _getWeeklyBuckets(allValues, 3);
      case '1M':
        return _getWeeklyBuckets(allValues, 4);
      case '3M':
        return _getMonthlyBuckets(allValues, 3);
      case '6M':
        return _getMonthlyBuckets(allValues, 6);
      case '1Y':
        return _getYearlyPoints(allValues, 2);
      case '5Y':
        return _getYearlyPoints(allValues, 6);
      case 'MAX':
        return _getMaxRangeData(allValues);
      default:
        return _getMonthlyBuckets(allValues, 6);
    }
  }

// New helper method for weekly buckets
  List<dynamic> _getWeeklyBuckets(List<dynamic> values, int weekCount) {
    final now = DateTime.now();
    final List<dynamic> data = [];

    for (int i = weekCount - 1; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: i * 7 + 6));
      final weekEnd = now.subtract(Duration(days: i * 7));

      final weekData = values.where((v) {
        final date = _parseDate(v.datetime);
        return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            date.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();

      if (weekData.isNotEmpty) {
        // Sort by date and take the most recent data point for the week
        weekData.sort(
            (a, b) => _parseDate(b.datetime).compareTo(_parseDate(a.datetime)));
        data.add(weekData.first);
      }
    }

    return data;
  }

// New helper method for monthly buckets
  List<dynamic> _getMonthlyBuckets(List<dynamic> values, int monthCount) {
    final now = DateTime.now();
    final List<dynamic> data = [];

    // Create list of target months (current month and previous months)
    final List<DateTime> targetMonths = [];
    for (int i = 0; i < monthCount; i++) {
      targetMonths.add(DateTime(now.year, now.month - i, 1));
    }

    // Reverse to get chronological order (oldest to newest)
    targetMonths.sort((a, b) => a.compareTo(b));

    for (final targetMonth in targetMonths) {
      final nextMonth = DateTime(targetMonth.year, targetMonth.month + 1, 1);

      final monthData = values.where((v) {
        final date = _parseDate(v.datetime);
        return date.isAfter(targetMonth.subtract(const Duration(days: 1))) &&
            date.isBefore(nextMonth);
      }).toList();

      if (monthData.isNotEmpty) {
        // Sort by date and take the most recent data point for the month
        monthData.sort(
            (a, b) => _parseDate(b.datetime).compareTo(_parseDate(a.datetime)));
        data.add(monthData.first);
      } else {
        // If no data for this month, try to find closest data point
        final closestData = _findClosestDataPoint(values, targetMonth);
        if (closestData != null) {
          data.add(closestData);
        }
      }
    }

    return data;
  }

// New helper method for yearly points
  List<dynamic> _getYearlyPoints(List<dynamic> values, int pointCount) {
    final now = DateTime.now();
    final List<dynamic> data = [];

    if (pointCount == 2) {
      // For 1Y: June 2024, June 2025 (or current month of previous year and current year)
      final currentMonth = now.month;
      final dates = [
        DateTime(now.year - 1, currentMonth, 1), // Same month last year
        DateTime(now.year, currentMonth, 1), // Same month this year
      ];

      for (final targetDate in dates) {
        final monthData = values.where((v) {
          final date = _parseDate(v.datetime);
          return date.year == targetDate.year && date.month == targetDate.month;
        }).toList();

        if (monthData.isNotEmpty) {
          monthData.sort((a, b) =>
              _parseDate(b.datetime).compareTo(_parseDate(a.datetime)));
          data.add(monthData.first);
        } else {
          // Try to find data from the same year if exact month not available
          final yearData = values.where((v) {
            final date = _parseDate(v.datetime);
            return date.year == targetDate.year;
          }).toList();

          if (yearData.isNotEmpty) {
            yearData.sort((a, b) =>
                _parseDate(b.datetime).compareTo(_parseDate(a.datetime)));
            data.add(yearData.first);
          }
        }
      }
    } else {
      // For 5Y: 6 yearly points spread across 5 years
      final List<DateTime> targetDates = [];
      final startYear = now.year - 4; // 5 years ago

      // Create 6 points across 5 years
      for (int i = 0; i < pointCount; i++) {
        final yearOffset = (i * 4) ~/ (pointCount - 1); // Spread across 5 years
        final targetYear = startYear + yearOffset;
        targetDates.add(DateTime(targetYear, now.month, 1));
      }

      for (final targetDate in targetDates) {
        final yearData = values.where((v) {
          final date = _parseDate(v.datetime);
          return date.year == targetDate.year;
        }).toList();

        if (yearData.isNotEmpty) {
          // Try to get data from the same month, otherwise get the most recent from that year
          final monthData = yearData.where((v) {
            final date = _parseDate(v.datetime);
            return date.month == targetDate.month;
          }).toList();

          if (monthData.isNotEmpty) {
            monthData.sort((a, b) =>
                _parseDate(b.datetime).compareTo(_parseDate(a.datetime)));
            data.add(monthData.first);
          } else {
            yearData.sort((a, b) =>
                _parseDate(b.datetime).compareTo(_parseDate(a.datetime)));
            data.add(yearData.first);
          }
        }
      }
    }

    return data;
  }

// Helper method to find closest data point to a target date
  dynamic _findClosestDataPoint(List<dynamic> values, DateTime targetDate) {
    if (values.isEmpty) return null;

    dynamic closest;
    Duration minDifference =
        const Duration(days: 365 * 10); // Large initial value

    for (final value in values) {
      final date = _parseDate(value.datetime);
      final difference = (date.difference(targetDate)).abs();

      if (difference < minDifference) {
        minDifference = difference;
        closest = value;
      }
    }

    return closest;
  }

  List<FlSpot> _toSpots(List<dynamic> values) {
    return values.asMap().entries.map((entry) {
      final price = double.tryParse(entry.value.close ?? '0') ?? 0;
      return FlSpot(entry.key.toDouble(), price * usdToInrRate);
    }).toList();
  }

  List<dynamic> _getLastNDays(List<dynamic> values, int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days - 1));
    return values
        .where((v) => _parseDate(v.datetime)
            .isAfter(cutoff.subtract(const Duration(days: 1))))
        .take(days)
        .toList()
        .reversed
        .toList();
  }


  List<dynamic> _getMaxRangeData(List<dynamic> values) {
    final sorted = [
      ...values
    ]..sort((a, b) => _parseDate(a.datetime).compareTo(_parseDate(b.datetime)));
    if (sorted.length >= 2) return [sorted.first, sorted.last];
    return sorted;
  }



  DateTime _parseDate(String? dateStr) {
    return DateTime.tryParse(dateStr ?? '') ?? DateTime.now();
  }

  Map<int, double> getReturnsForYears(List<dynamic> values) {
    final currentYear = DateTime.now().year;
    final List<int> lastFiveYears =
        List.generate(5, (index) => currentYear - 4 + index);

    final Map<int, double> yearlyReturns = {};
    for (final year in lastFiveYears) {
      final ret = calculateYearlyReturn(values, year);
      yearlyReturns[year] = ret;
    }
    return yearlyReturns;
  }

  double calculateYearlyReturn(List<dynamic> values, int year) {
    final yearData =
        values.where((v) => DateTime.parse(v.datetime!).year == year).toList();
    if (yearData.isEmpty) return 0;

    double start = double.tryParse(yearData.last.close ?? '') ?? 0;
    double end = double.tryParse(yearData.first.close ?? '') ?? 0;

    return (end - start) * StockDetailViewmodel.usdToInrRate;
  }

  Map<int, String> get xAxisLabelMap {
    final List<DateTime> dates = filteredDates;
    final Map<int, String> labels = {};

    int step;
    switch (_selectedRange) {
      case '1W':
        step = 1; // 7 labels
        break;
      case '3W':
      case '1M':
        step = (dates.length ~/ 4).clamp(1, dates.length); // 4 labels
        break;
      case '6M':
        step = (dates.length ~/ 6).clamp(1, dates.length); // 6 labels
        break;
      case '1Y':
      case 'MAX':
        step = (dates.length ~/ 2).clamp(1, dates.length); // 2 labels
        break;
      case '5Y':
        step = (dates.length ~/ 6).clamp(1, dates.length); // 6 labels
        break;
      default:
        step = 1;
    }

    for (int i = 0; i < dates.length; i += step) {
      final date = dates[i];
      labels[i] = _getFormattedLabel(date, _selectedRange);
    }

    // Ensure last point is labeled
    if (!labels.containsKey(dates.length - 1)) {
      labels[dates.length - 1] = _getFormattedLabel(dates.last, _selectedRange);
    }

    return labels;
  }

  String _getFormattedLabel(DateTime date, String range) {
    switch (range) {
      case '1W':
        return DateFormat('MMM dd').format(date);
      case '3W':
      case '1M':
        final end = date.add(const Duration(days: 6));
        return '${DateFormat('MMM dd').format(date)} - ${DateFormat('dd').format(end)}';
      case '6M':
        return DateFormat('MMM').format(date);
      case '1Y':
      case '5Y':
      case 'MAX':
        return DateFormat('MMM yyyy').format(date);
      default:
        return DateFormat('MMM dd').format(date);
    }
  }
}
