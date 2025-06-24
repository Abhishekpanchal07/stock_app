import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/screens/stock_detail/widgets/line_chart_widget.dart';
import 'package:beyond_stock_app/screens/stock_detail/widgets/performance_in_event_chart.dart';
import 'package:beyond_stock_app/screens/stock_detail/widgets/stock_description_widget.dart';
import 'package:beyond_stock_app/screens/stock_detail/widgets/yearly_return_chart.dart';
import 'package:beyond_stock_app/view_model/stock_detail_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockDetailScreen extends StatefulWidget {
  final String? stockSymbol;
  final String? stockName;
  const StockDetailScreen({super.key, this.stockSymbol, this.stockName});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late StockDetailViewmodel stockDetailVM;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      stockDetailVM = context.read<StockDetailViewmodel>();
      await stockDetailVM
          .fetchStockDetail(stockSymbol: widget.stockSymbol ?? "")
          .then((_) async {
        await stockDetailVM.fetchBenchmarkDetail();
      });
    });
  }

  @override
  void dispose() {
    stockDetailVM.updateSelectedRangeToDefault = "6M";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.blackColor,
      appBar: CustomAppBar(
        title: '',
        backgroundColor: ColorConstants.blackColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StockDescriptionWidget(
              stockName: widget.stockName,
            ),
            LineChartWidget(),
            SizedBox(
              height: 16,
            ),
            YearlyReturnsChart(),
            SizedBox(
              height: 16,
            ),
            PerformanceInEventsChart()
          ],
        ),
      ),
    );
  }
}
