import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_app_bar.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_sheet.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_button.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

class AddStock extends StatelessWidget {
  const AddStock({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> stockList = [
      'ICICI Bank Growth Fund Direct Plan',
      'Adani Enterprises BSE Sensex Index Fund Direct Plan',
      'Wipro Nifty200 Momentum 30 Index Fund',
      'Axis Bank BSE Sensex Index Fund Direct Plan',
      'Tata Motors Nifty Next 50 Index Fund',
    ];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: StringConstants.addStock,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            children: [
              // Search Bar
              CustomSearchBar(),
              SizedBox(height: 16),
              // List
              Expanded(
                child: ListView.separated(
                  itemCount: stockList.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.white24),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          showCustomBottomSheet(
                            context: context,
                            title: StringConstants.addToWatchList,
                            description:
                                StringConstants.followingStockAddedText,
                            content: 'HDFC Bank Large Cap Fund Direct Growth ',
                            istButton: CustomButton(
                              text: StringConstants.addToWatchList,
                              onPressed: () {
                                // handle add
                                Navigator.pop(context);
                              },
                              buttonColor: Colors.white,
                              textColor: Colors.black,
                              borderColor: Colors.transparent,
                            ),
                            secondButton: CustomButton(
                              text: StringConstants.cancel,
                              /* onPressed: () {
                                // handle add
                                Navigator.pop(context);
                              }, */
                              buttonColor: ColorConstants.scaffoldBgColor,
                              textColor: ColorConstants.whiteColor,
                              borderColor: Colors.transparent,
                            ),
                          );
                        },
                        child: Text(
                          stockList[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
