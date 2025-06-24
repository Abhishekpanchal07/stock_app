import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:beyond_stock_app/view_model/stock_detail_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockDescriptionWidget extends StatelessWidget {
  final String? stockName;
  const StockDescriptionWidget({super.key, this.stockName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStockName(),
          const SizedBox(height: 10),
          _buildTrackStockText(),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStockStatus(
                color: ColorConstants.red,
                imagePath: SvgImageConstants.highRiskIcon,
                text: StringConstants.highRisk,
              ),
              const SizedBox(width: 12),
              _buildStockStatus(
                color: ColorConstants.addButtonColor,
                imagePath: SvgImageConstants.suitsCurrentMarketIcon,
                text: StringConstants.suitsCurrentMarket,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 👇 New row for Min Amount and CAGR with Selectors
          Row(
            children: [
              _MinAmountWidget(),
              const SizedBox(width: 32),
              _TwoYearCAGRWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockName() {
    return Text(
      stockName ?? StringConstants.stockNameNotAvailable,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildTrackStockText() {
    return Text(
      StringConstants.trackStocksShowingSuddenText,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      style: TextStyle(
        fontFamily: StringConstants.fontFamily,
        fontSize: 15,
        color: ColorConstants.darkGreyColor,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildStockStatus({
    required String imagePath,
    required Color color,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          SvgImage(
            imagePath: imagePath,
            height: 12,
            width: 12,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontFamily: StringConstants.fontFamily,
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class _MinAmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<StockDetailViewmodel, double?>(
      selector: (_, vm) => double.tryParse(vm.formattedMinInvestmentAmount),
      builder: (_, minAmount, __) {
        return _minAmountAndCAGRWidget(
            istText: minAmount,
            secondText: StringConstants.minAmount,
            textColor: ColorConstants.greyText,
            context: context);
      },
    );
  }
}

class _TwoYearCAGRWidget extends StatelessWidget {
  const _TwoYearCAGRWidget();

  @override
  Widget build(BuildContext context) {
    return Selector<StockDetailViewmodel, double?>(
      selector: (_, vm) => double.tryParse(vm.formattedTwoYearCAGR),
      builder: (_, twoyearCAGR, __) {
        return _minAmountAndCAGRWidget(
            istText: twoyearCAGR,
            showRupees: false,
            secondText: StringConstants.cagr,
            textColor: ColorConstants.green,
            context: context);
      },
    );
  }
}

Widget _minAmountAndCAGRWidget(
    {required double? istText,
    bool showRupees = true,
    required String secondText,
    required BuildContext context,
    Color? textColor}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      showRupees
          ? Text(
              "₹${istText?.toStringAsFixed(0) ?? "0.0"}",
            )
          : Text(
              "${istText?.toStringAsFixed(0) ?? "0.0"}%",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: textColor),
            ),
      SizedBox(
        height: 6,
      ),
      Text(
        secondText,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: ColorConstants.greyText),
      ),
    ],
  );
}
