import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/view_model/search_stock_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_app_bar.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_sheet.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_button.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_loader.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStock extends StatelessWidget {
  const AddStock({super.key});

  @override
  Widget build(BuildContext context) {
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
              Consumer<SearchStockViewmodel>(
                builder: (context, viewModel, child) {
                  return CustomSearchBar(
                    onChanged: viewModel.onSearchTextChanged,
                  );
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Selector<SearchStockViewmodel, bool>(
                  selector: (_, vm) => vm.showProgressLoader,
                  builder: (_, showLoader, __) {
                    if (showLoader) {
                      return const CustomLoader(
                          message: StringConstants.fetchingResults);
                    }

                    return Consumer<SearchStockViewmodel>(
                      builder: (_, vm, __) {
                        final stockList = vm.searchResultList;

                        if (stockList.isEmpty) {
                          return Center(
                            child: Text(
                              vm.hasSearched
                                  ? StringConstants.noMatchingResultFound
                                  : StringConstants.searchAndAddStocks,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: stockList.length,
                          itemBuilder: (context, index) {
                            final item = stockList[index];

                            return GestureDetector(
                              onTap: () {
                                _addStockBottomSheet(
                                    context: context, content: item.name);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  item.name ?? '',
                                  style: const TextStyle(
                                    color: ColorConstants.whiteColor,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(
                            child: const Divider(
                              color: ColorConstants.whiteColor,
                              thickness: 1,
                              height: 1,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addStockBottomSheet({required BuildContext context, String? content}) {
    showCustomBottomSheet(
      context: context,
      title: StringConstants.addToWatchList,
      description: StringConstants.followingStockAddedText,
      content: content ?? 'Unknown Stock',
      istButton: CustomButton(
        text: StringConstants.addToWatchList,
        onPressed: () => Navigator.pop(context),
        buttonColor: ColorConstants.whiteColor,
        textColor: ColorConstants.blackColor,
        borderColor: Colors.transparent,
      ),
      secondButton: CustomButton(
        text: StringConstants.cancel,
        buttonColor: ColorConstants.scaffoldBgColor,
        textColor: ColorConstants.whiteColor,
        borderColor: Colors.transparent,
      ),
    );
  }
}
