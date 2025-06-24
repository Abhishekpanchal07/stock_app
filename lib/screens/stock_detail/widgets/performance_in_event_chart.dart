import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/screens/stock_detail/widgets/yearly_return_chart.dart';
import 'package:beyond_stock_app/view_model/stock_detail_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_loader.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerformanceInEventsChart extends StatelessWidget {
  const PerformanceInEventsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Selector<StockDetailViewmodel, bool>(
        selector: (_, viewModel) => viewModel.showProgressLoader,
        builder: (_, isLoading, __) {
          if (isLoading) {
            return const SizedBox(
              height: 300,
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
              // Get dynamic data similar to yearly returns
              final stockReturns = viewModel.getEventPerformanceStockReturns();
              final benchmarkReturns = viewModel.getEventPerformanceBenchmarkReturns();
              
              final events = viewModel.eventLabels; // e.g., ['2008 Crisis', 'COVID-19', 'Financial Crisis']

              if (events.isEmpty || stockReturns.isEmpty || benchmarkReturns.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CustomLoader(
                      message: StringConstants.noDataAvailable,
                      loaderColor: ColorConstants.red,
                      textColor: ColorConstants.whiteColor,
                    ),
                  ),
                );
              }

              final chartMetrics = _calculateChartMetrics(
                [...stockReturns.values, ...benchmarkReturns.values],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 24),
                    child: Text(
                      'Performance in Events',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 260,
                    margin: const EdgeInsets.only(left: 20, right: 25, top: 24),
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final value = rod.toY.toStringAsFixed(2);
                              final label = rodIndex == 0 ? 'Stock: ₹$value' : 'Benchmark: ₹$value';
                              return BarTooltipItem(
                                label,
                                TextStyle(
                                  color: rod.color ?? Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                        maxY: chartMetrics.maxY,
                        minY: chartMetrics.minY,
                        barGroups: events.asMap().entries.map((entry) {
                          final index = entry.key;
                          final event = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barsSpace: 8, // Increased space between bar groups
                            barRods: [
                              BarChartRodData(
                                toY: stockReturns[event] ?? 0,
                                color: ColorConstants.addButtonColor,
                                width: 16, // Increased bar width from 8 to 16
                                borderRadius: BorderRadius.zero,
                              ),
                              BarChartRodData(
                                toY: benchmarkReturns[event] ?? 0,
                                color: ColorConstants.greyText,
                                width: 16, // Increased bar width from 8 to 16
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
                                if (index >= 0 && index < events.length) {
                                  final event = events[index];
                                  final stock = stockReturns[event] ?? 0;
                                  final benchmark = benchmarkReturns[event] ?? 0;

                                  Color? indicatorColor;
                                  if (stock > benchmark) {
                                    indicatorColor = ColorConstants.addButtonColor;
                                  } else if (benchmark > stock) {
                                    indicatorColor = ColorConstants.greyText;
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        event,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 12,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: indicatorColor,
                                          borderRadius: BorderRadius.circular(1),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              interval: chartMetrics.interval,
                              reservedSize: 50,
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                return Text(
                                  '₹${(value ~/ 1000)}k',
                                  style: const TextStyle(color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: false,
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      LegendItem(
                        color: ColorConstants.addButtonColor, 
                        text: "Short-Term Trend Catcher"
                      ),
                      SizedBox(width: 16),
                      LegendItem(
                        color: ColorConstants.greyText, 
                        text: "Benchmark"
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  _ChartMetrics _calculateChartMetrics(List<double> allValues) {
    if (allValues.isEmpty) {
      return _ChartMetrics(0, 10000, 2500);
    }

    final maxVal = allValues.reduce((a, b) => a > b ? a : b);
    final minVal = allValues.reduce((a, b) => a < b ? a : b);

    final roundedMax = ((maxVal / 10000).ceil()) * 10000;
    final roundedMin = ((minVal / 10000).floor()) * 10000;

    final maxY = roundedMax == 0 ? 10000 : roundedMax.toDouble();
    final minY = roundedMin > 0 ? 0 : roundedMin.toDouble();
    final interval = ((maxY - minY) / 4).abs();

    return _ChartMetrics(
      double.tryParse(minY.toString()) ?? 0.0,
      double.tryParse(maxY.toString()) ?? 0.0,
      interval,
    );
  }
}

class _ChartMetrics {
  final double minY;
  final double maxY;
  final double interval;

  _ChartMetrics(this.minY, this.maxY, this.interval);
}