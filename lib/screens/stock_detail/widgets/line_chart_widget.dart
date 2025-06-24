import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:beyond_stock_app/view_model/stock_detail_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_loader.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/svg_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Selector<StockDetailViewmodel, bool>(
        selector: (_, viewModel) => viewModel.showProgressLoader,
        builder: (_, isLoading, __) {
          if (isLoading) {
            return const SizedBox(
              height: 485,
              child: Center(
                child: CustomLoader(
                  message: StringConstants.loadingPerformanceData,
                  loaderColor: ColorConstants.addButtonColor,
                  textColor: ColorConstants.whiteColor,
                ),
              ),
            );
          }

          return Consumer<StockDetailViewmodel>(
            builder: (context, viewModel, _) {
              final stockSpots = viewModel.filteredStockSpots;
              final benchmarkSpots = viewModel.filteredBenchmarkSpots;
              final filteredDates = viewModel.filteredDates;
              final percentChange = viewModel.stockReturnPercent;

              if (stockSpots.isEmpty) {
                return SizedBox(
                  height: 485,
                  child: Center(
                    child: Text(StringConstants.noDataAvailable,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                );
              }

              return Container(
                height: 485,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: ColorConstants.scaffoldBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ChartHeader(),
                    const _RangeSelector(),
                    _ChartSummary(percentChange: percentChange),
                    const Divider(color: ColorConstants.blackColor, height: 1),
                    const SizedBox(height: 33),
                    _LineChartContent(
                      stockSpots: stockSpots,
                      benchmarkSpots: benchmarkSpots,
                      filteredDates: filteredDates,
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    });
  }
}

class _ChartHeader extends StatelessWidget {
  const _ChartHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            StringConstants.livePerformance,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: ColorConstants.blackColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(
                  StringConstants.equityLargeCap,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstants.greyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                ),
                const SizedBox(width: 10),
                SvgImage(
                  imagePath: SvgImageConstants.dropDownIcon,
                  height: 6,
                  width: 10,
                  colorFilter: const ColorFilter.mode(
                      ColorConstants.whiteColor, BlendMode.srcIn),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector();

  @override
  Widget build(BuildContext context) {
    final filters = ['1W', '3W', '1M', '3M', '6M', '1Y', '5Y', 'MAX'];

    return Selector<StockDetailViewmodel, String>(
      selector: (_, vm) => vm.selectedRange,
      builder: (_, selectedRange, __) {
        final viewModel = context.read<StockDetailViewmodel>();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((range) {
              final isSelected = selectedRange == range;
              return GestureDetector(
                onTap: () => viewModel.updateSelectedRange(range),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? ColorConstants.addButtonColor
                          : ColorConstants.scaffoldBgColor,
                    ),
                    color: isSelected
                        ? ColorConstants.scaffoldBgColor
                        : ColorConstants.blackColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    range,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? ColorConstants.addButtonColor
                              : ColorConstants.greyText,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _ChartSummary extends StatelessWidget {
  final double percentChange;
  const _ChartSummary({required this.percentChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${percentChange.toStringAsFixed(2)}%",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: percentChange >= 0
                      ? ColorConstants.addButtonColor
                      : ColorConstants.crimsonRed,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            StringConstants.thisStock,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstants.darkGreyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
          ),
        ],
      ),
    );
  }
}

class _LineChartContent extends StatelessWidget {
  final List<FlSpot> stockSpots;
  final List<FlSpot> benchmarkSpots;
  final List<DateTime> filteredDates;

  const _LineChartContent({
    required this.stockSpots,
    required this.benchmarkSpots,
    required this.filteredDates,
  });

  @override
  Widget build(BuildContext context) {
    final selectedRange = context.read<StockDetailViewmodel>().selectedRange;

    final chartMetrics = _calculateChartMetrics(stockSpots, benchmarkSpots);
    final minY = chartMetrics.minY;
    final maxY = chartMetrics.maxY;
    final intervalY = chartMetrics.yInterval;
    //  const xInterval = 1.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 4),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                // tooltipBgColor: Colors.black87,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    final textColor =
                        touchedSpot.bar.color == ColorConstants.crimsonRed
                            ? ColorConstants.red
                            : ColorConstants.addButtonColor;

                    return LineTooltipItem(
                      "₹${touchedSpot.y.toStringAsFixed(2)}",
                      TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            minX: 0,
            maxX: stockSpots.length - 1.toDouble(),
            minY: minY,
            maxY: maxY,
            backgroundColor: Colors.transparent,
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: ColorConstants.greyText,
                strokeWidth: 0.5,
              ),
              horizontalInterval: intervalY,
            ),
            extraLinesData: ExtraLinesData(horizontalLines: [
              HorizontalLine(
                y: maxY,
                color: ColorConstants.greyText,
                strokeWidth: 0.5,
              )
            ]),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: intervalY,
                  getTitlesWidget: (value, _) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      _formatYAxis(value),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval:
                      _getXAxisInterval(filteredDates.length, selectedRange),
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index >= 0 && index < filteredDates.length) {
                      // Only show labels at specific intervals based on the range
                      if (_shouldShowXAxisLabel(
                          index, filteredDates.length, selectedRange)) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _formatXAxis(filteredDates[index], index,
                                filteredDates.length, selectedRange),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 9),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                spots: benchmarkSpots,
                color: ColorConstants.crimsonRed,
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                isCurved: true,
                spots: stockSpots,
                color: Colors.tealAccent,
                barWidth: 2.5,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatYAxis(double value) {
    if (value == 0) return "₹0";
    if (value >= 1000) return "₹${(value / 1000).toStringAsFixed(0)}K";
    return "₹${value.toStringAsFixed(0)}";
  }

  String _formatXAxis(
    DateTime date,
    int index,
    int totalLength,
    String selectedRange,
  ) {
    switch (selectedRange) {
      case '1W':
        // 7 days in MM dd format
        return DateFormat('MMM dd').format(date);

      case '3W':
        // 3 weeks as "MMM dd - dd"
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return '${DateFormat('MMM dd').format(weekStart)} - ${DateFormat('dd').format(weekEnd)}';

      case '1M':
        // 4 weekly buckets (MMM dd - dd)
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return '${DateFormat('MMM dd').format(weekStart)} - ${DateFormat('dd').format(weekEnd)}';

      case '3M':
      case '6M':
        {
          final currentMonth = date.month;
          final previousDate = index > 0 ? filteredDates[index - 1] : null;
          final previousMonth = previousDate?.month;
          if (currentMonth != previousMonth) {
            return DateFormat('MMM').format(date);
          } else {
            return '';
          }
        }

      case '1Y':
      case '5Y':
      case 'MAX':
        {
          final currentLabel = DateFormat('MMM yyyy').format(date);
          final previousDate = index > 0 ? filteredDates[index - 1] : null;
          final previousLabel = previousDate != null
              ? DateFormat('MMM yyyy').format(previousDate)
              : null;
          if (currentLabel != previousLabel) {
            return currentLabel;
          } else {
            return '';
          }
        }

      default:
        return DateFormat('MMM dd').format(date);
    }
  }

  double _getXAxisInterval(int dataLength, String selectedRange) {
    switch (selectedRange) {
      case '1W':
        return 1.0; // Show all 7 days
      case '3W':
        return 1.0; // Show all 3 weeks
      case '1M':
        return 1.0; // Show all 4 weeks
      case '6M':
        return 1.0; // Show all 6 months
      case '1Y':
        return 1.0; // Show both points
      case '5Y':
        return 1.0; // Show all 6 points
      default:
        return 1.0;
    }
  }

// Helper method to determine which labels to show
  bool _shouldShowXAxisLabel(int index, int totalLength, String selectedRange) {
    switch (selectedRange) {
      case '1W':
        return true; // Show all 7 labels
      case '3W':
        return true; // Show all 3 labels
      case '1M':
        return true; // Show all 4 labels
      case '3M':
        return true; // Show all 3 labels
      case '6M':
        return true; // Show all 6 labels
      case '1Y':
        return true; // Show both labels
      case '5Y':
        return true; // Show all 6 labels
      default:
        return index % 2 == 0; // Show every other label as fallback
    }
  }
}

class _ChartMetrics {
  final double minY;
  final double maxY;
  final double yInterval;

  _ChartMetrics(this.minY, this.maxY, this.yInterval);
}

_ChartMetrics _calculateChartMetrics(
  List<FlSpot> stockSpots,
  List<FlSpot> benchmarkSpots,
) {
  final allYValues = [
    ...stockSpots.map((e) => e.y),
    ...benchmarkSpots.map((e) => e.y),
  ];

  if (allYValues.isEmpty) {
    return _ChartMetrics(0, 10000, 2500);
  }

  final maxVal = allYValues.reduce((a, b) => a > b ? a : b);
  final minVal = allYValues.reduce((a, b) => a < b ? a : b);

  final roundedMax = ((maxVal / 10000).ceil()) * 10000;
  final roundedMin = ((minVal / 10000).floor()) * 10000;

  final maxY = roundedMax == 0 ? 10000 : roundedMax.toDouble();
  final minY = roundedMin > 0 ? 0 : roundedMin.toDouble();
  final yInterval = ((maxY - minY) / 4).abs();

  return _ChartMetrics(double.tryParse(minY.toString()) ?? 0.0,
      double.tryParse(maxY.toString()) ?? 0.0, yInterval);
}
