import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/view_model/stock_detail_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_loader.dart';

class YearlyReturnsChart extends StatelessWidget {
  const YearlyReturnsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Selector<StockDetailViewmodel, bool>(
          selector: (_, viewModel) => viewModel.showProgressLoader,
          builder: (_, isLoading, __) {
            if (isLoading) {
              return const SizedBox(
                height: 485,
                child: Center(
                  child: CustomLoader(
                    message: StringConstants.loadingYearlyData,
                    loaderColor: ColorConstants.addButtonColor,
                    textColor: ColorConstants.whiteColor,
                  ),
                ),
              );
            }

            return Consumer<StockDetailViewmodel>(
              builder: (context, viewModel, _) {
                final stockReturns = viewModel
                    .getReturnsForYears(viewModel.stockDetail?.values ?? []);
                final benchmarkReturns = viewModel
                    .getReturnsForYears(viewModel.benchmark?.values ?? []);

                final years = {...stockReturns.keys, ...benchmarkReturns.keys}
                    .toList()
                  ..sort();

                if (years.isEmpty) {
                  return const SizedBox(
                    height: 485,
                    child: Center(
                      child: CustomLoader(
                        message: StringConstants.noDataAvailable,
                        loaderColor: ColorConstants.red,
                        textColor: ColorConstants.whiteColor,
                      ),
                    ),
                  );
                }

                final yearIndexMap = {
                  for (int i = 0; i < years.length; i++) years[i]: i
                };
                final chartMetrics =
                    _calculateChartMetrics(stockReturns, benchmarkReturns);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(context),
                    _buildChart(stockReturns, benchmarkReturns, years,
                        yearIndexMap, chartMetrics),
                    const SizedBox(height: 16),
                    _buildLegend(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 48),
      child: Text(
        StringConstants.calenderYearlyPerformance,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }

  Widget _buildChart(
    Map<int, double> stockReturns,
    Map<int, double> benchmarkReturns,
    List<int> years,
    Map<int, int> yearIndexMap,
    _ChartMetrics metrics,
  ) {
    return Container(
      height: 260,
      margin: const EdgeInsets.only(left: 20, right: 25, top: 24),
      child: BarChart(
        BarChartData(
          maxY: metrics.maxY,
          minY: metrics.minY,
          barGroups: years.map((year) {
            final index = yearIndexMap[year]!;
            return BarChartGroupData(
              x: index,
              barsSpace: 6,
              barRods: [
                BarChartRodData(
                  toY: stockReturns[year] ?? 0,
                  color: Colors.cyanAccent,
                  width: 8,
                  borderRadius: BorderRadius.zero,
                ),
                BarChartRodData(
                  toY: benchmarkReturns[year] ?? 0,
                  color: Colors.grey[700],
                  width: 8,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40,
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  return (index >= 0 && index < years.length)
                      ? Text(years[index].toString(),
                          style: const TextStyle(color: Colors.grey))
                      : const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: metrics.yInterval,
                reservedSize: 50,
                showTitles: true,
                getTitlesWidget: (value, _) {
                  return Text('₹${(value ~/ 1000)}k',
                      style: const TextStyle(color: Colors.grey));
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: metrics.yInterval,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: ColorConstants.searchStockColor,
              strokeWidth: 1,
            ),
            checkToShowHorizontalLine: (value) {
              // Only show lines at intervals (excluding maxY here to avoid double-line if same)
              return value % metrics.yInterval == 0;
            },
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: metrics.maxY,
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [5, 2], // Optional: make it dashed to differentiate
              ),
            ],
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        LegendItem(color: Colors.cyanAccent, text: "Short Term Trend Catcher"),
        SizedBox(width: 16),
        LegendItem(color: Colors.grey, text: "Benchmark"),
      ],
    );
  }

  _ChartMetrics _calculateChartMetrics(
    Map<int, double> stockReturns,
    Map<int, double> benchmarkReturns,
  ) {
    final allReturns = [...stockReturns.values, ...benchmarkReturns.values];
    if (allReturns.isEmpty) {
      return _ChartMetrics(0, 10000, 2500); // default
    }

    final maxVal = allReturns.reduce((a, b) => a > b ? a : b);
    final minVal = allReturns.reduce((a, b) => a < b ? a : b);

    final roundedMax = ((maxVal / 10000).ceil()) * 10000;
    final roundedMin = ((minVal / 10000).floor()) * 10000;

    final maxY = roundedMax == 0 ? 10000 : roundedMax.toDouble();
    final minY = roundedMin > 0 ? 0 : roundedMin.toDouble();
    final yInterval = ((maxY - minY) / 4).abs();

    return _ChartMetrics(double.tryParse(minY.toString()) ?? 0.0,
        double.tryParse(maxY.toString()) ?? 0.0, yInterval);
  }
}

/// Simple struct for chart Y axis config
class _ChartMetrics {
  final double minY;
  final double maxY;
  final double yInterval;

  _ChartMetrics(this.minY, this.maxY, this.yInterval);
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
