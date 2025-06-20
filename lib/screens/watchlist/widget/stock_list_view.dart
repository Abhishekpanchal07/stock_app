// stock_tile.dart
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_sheet.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/svg_image.dart';

class StockListView extends StatelessWidget {
  const StockListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> stockList = [
      {
        'name': 'HDFC Bank Large Cap Fund Direct',
        'priceChange': '+₹147.23',
        'percentage': '(0.54%)',
        'isPositive': true,
      },
      {
        'name': 'Reliance Industries BSE Sensex Index Fund Direct Growth',
        'priceChange': '+₹47.88',
        'percentage': '(0.54%)',
        'isPositive': true,
      },
      {
        'name': 'Infosys Nifty Next 50 Index Fund',
        'priceChange': '-₹47.88',
        'percentage': '(0.54%)',
        'isPositive': false,
      },
    ];

    return ListView.separated(
      itemCount: stockList.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (_, __) => const Divider(
        color: ColorConstants.blackColor,
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final stock = stockList[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(0), // Optional, use 12 if needed
          clipBehavior: Clip.hardEdge,
          child: Slidable(
            key: ValueKey(stock['name']),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.2,
              children: [
                CustomSlidableAction(
                  onPressed: (_) {
                    _deleteStockBottomSheet(
                        context: context, content: stock['name']);
                  },
                  backgroundColor: Colors.transparent,
                  autoClose: true,
                  padding: EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SvgImage(
                      imagePath: SvgImageConstants.deleteIcon,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ],
            ),
            child: Container(
              color: Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      stock['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        stock['priceChange'],
                        style: TextStyle(
                          color:
                              stock['isPositive'] ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stock['percentage'],
                        style: TextStyle(
                          color:
                              stock['isPositive'] ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteStockBottomSheet(
      {required BuildContext context, String? content}) {
    showCustomBottomSheet(
      context: context,
      title: StringConstants.deleteFromwatchList,
      description: StringConstants.followingStockDeleteText,
      content: content ?? 'Unknown Stock',
      istButton: CustomButton(
        text: StringConstants.deleteStock,
        onPressed: () => Navigator.pop(context),
        buttonColor: ColorConstants.scaffoldBgColor,
        textColor: ColorConstants.deleteStockColor,
        borderColor: ColorConstants.deleteStockColor,
      ),
      secondButton: CustomButton(
        text: StringConstants.cancel,
        buttonColor: ColorConstants.whiteColor,
        textColor: ColorConstants.blackColor,
        borderColor: Colors.transparent,
      ),
    );
  }
}
