import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/modals/search_result_model.dart';
import 'package:beyond_stock_app/view_model/search_stock_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_app_bar.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_sheet.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_button.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_loader.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorConstants.blackColor,
        appBar: CustomAppBar(
          backgroundColor: ColorConstants.blackColor,
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
                    controller: _searchController,
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
                                    context: context, stock: item);
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
                              color: ColorConstants.scaffoldBgColor,
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

  void _addStockBottomSheet(
      {required BuildContext context, SearchResultModel? stock}) {
    showCustomBottomSheet(
      context: context,
      title: StringConstants.addToWatchList,
      description: StringConstants.followingStockAddedText,
      content: stock?.name ?? 'Unknown Stock',
      istButton: CustomButton(
        text: StringConstants.addToWatchList,
        onPressed: () async {
          final viewModel = context.read<SearchStockViewmodel>();
          await viewModel.addToWatchlist(stock ?? SearchResultModel());
          if (context.mounted) {
            Navigator.pop(context);

            viewModel.clearSearch(); // clears list & viewmodel text
            _searchController.clear(); // clears UI text
          }
        },
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
