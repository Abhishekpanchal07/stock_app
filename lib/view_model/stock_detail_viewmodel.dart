import 'dart:math';
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

   

  Map<String, List<double>> getEventPerformanceReturns() {
    return {
      'stock': [12000, 8000, 9000],
      'benchmark': [10000, 8500, 9200],
      'peer': [11000, 7800, 8900],
    };
  }

  // Getters
double? get minInvestmentAmount => 
    getMinimumInvestmentAmount(stockDetail?.values) != null
        ? getMinimumInvestmentAmount(stockDetail?.values)! * usdToInrRate
        : null;

double? get twoYearCAGR =>
    calculateTwoYearCAGR(stockDetail?.values);

// Optional UI formatted gettersa
String get formattedMinInvestmentAmount => formatCurrency(minInvestmentAmount);
String get formattedTwoYearCAGR => formatCAGR(twoYearCAGR);


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
      debugPrint("Error fetching stock: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchBenchmarkDetail() async {
    _setLoading(true);
    try {
      benchmark = await timeSeriesApiService.fetchBenchmarkDetail();
    } catch (e) {
      debugPrint("Error fetching benchmark: $e");
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

    // Reverse to get chronodebugPrintical order (oldest to newest)
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

  double? getMinimumInvestmentAmount(List<dynamic>? values) {
  if (values == null || values.isEmpty) return null;

  final minClose = values
      .map((v) => double.tryParse(v.close ?? '') ?? double.infinity)
      .reduce((a, b) => a < b ? a : b);

  return minClose;
} 
String formatCurrency(double? value) {
  if (value == null) return "-";
  return "₹${value.toStringAsFixed(0)}";
}


double? calculateTwoYearCAGR(List<dynamic>? values) {
  if (values == null || values.length < 2) return null;

  final twoYearsAgo = DateTime.now().subtract(Duration(days: 730));
  dynamic initial;
  dynamic latest;

  // Ensure chronodebugPrintical order
  final sorted = [...values]..sort((a, b) =>
      DateTime.parse(a.datetime!).compareTo(DateTime.parse(b.datetime!)));

  for (var val in sorted) {
    final date = DateTime.tryParse(val.datetime ?? '');
    if (date == null) continue;
    if (date.isBefore(twoYearsAgo)) {
      initial = val;
    }
    latest = val; // last non-null entry
  }

  if (initial == null || latest == null) return null;

  final initialValue = double.tryParse(initial.close ?? '');
  final finalValue = double.tryParse(latest.close ?? '');

  if (initialValue == null || finalValue == null || initialValue == 0) {
    return null;
  }

  final cagr = pow(finalValue / initialValue, 1 / 2) - 1;
  return cagr * 100;
}

String formatCAGR(double? value) {
  if (value == null) return "-";
  return "${value.toStringAsFixed(2)}%";
}

 // In StockDetailViewmodel
List<String> get eventLabels => ['2008 Crisis', 'COVID-19', 'Financial Crisis'];

Map<String, double> getEventPerformanceStockReturns() {
  // Replace with your actual calculation logic
  // This should return dynamic values based on stock performance during these events
  return {
    '2008 Crisis': 21200,
    'COVID-19': 29900,
    'Financial Crisis': 26900,
  };
}

Map<String, double> getEventPerformanceBenchmarkReturns() {
  // Replace with your actual calculation logic
  // This should return dynamic values based on benchmark performance during these events
  return {
    '2008 Crisis': 23900,
    'COVID-19': 30000,
    'Financial Crisis': 23000,
  };
}

 
}
