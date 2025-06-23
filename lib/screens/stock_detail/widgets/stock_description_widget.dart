import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/svg_image.dart';
import 'package:flutter/material.dart';

class StockDescriptionWidget extends StatelessWidget {
  final String? stockName;
  const StockDescriptionWidget({super.key, this.stockName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStockName(),
          SizedBox(
            height: 10,
          ),
          _buildTrackStockText(),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              _buildStockStatus(
                  color: ColorConstants.red,
                  imagePath: SvgImageConstants.highRiskIcon,
                  text: StringConstants.highRisk),
              SizedBox(
                width: 12,
              ),
              _buildStockStatus(
                  color: ColorConstants.addButtonColor,
                  imagePath: SvgImageConstants.suitsCurrentMarketIcon,
                  text: StringConstants.suitsCurrentMarket),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStockName() {
    return Text(stockName ?? StringConstants.stockNameNotAvailable,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
            fontFamily: StringConstants.fontFamily,
            fontSize: 32,
            fontWeight: FontWeight.w400));
  }

  Widget _buildTrackStockText() {
    return Text(StringConstants.trackStocksShowingSuddenText,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: TextStyle(
            fontFamily: StringConstants.fontFamily,
            fontSize: 15,
            color: ColorConstants.darkGreyColor,
            fontWeight: FontWeight.w300));
  }

  Widget _buildStockStatus(
      {required String imagePath, required Color color, required String text}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          SvgImage(
            imagePath: imagePath,
            height: 12,
            width: 12,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  fontFamily: StringConstants.fontFamily,
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w300))
        ],
      ),
    );
  }
}
