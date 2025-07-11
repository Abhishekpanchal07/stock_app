
import 'package:beyond_stock_app/core/constants/parameter_key_constants.dart';
import 'package:beyond_stock_app/core/constants/route_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/modals/search_result_model.dart';
import 'package:beyond_stock_app/view_model/search_stock_viewmodel.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_sheet.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_button.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_loader.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/svg_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StockListView extends StatefulWidget {
  const StockListView({super.key});

  @override
  State<StockListView> createState() => _StockListViewState();
}

class _StockListViewState extends State<StockListView> {
  @override
  void initState() {
    super.initState();

    /// Load watchlist after widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<SearchStockViewmodel>();
      viewModel.loadWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchStockViewmodel>(
      builder: (context, vm, child) {
        if (vm.isWatchlistLoading) {
          return const CustomLoader(message: StringConstants.fetchingWatchlist);
        }

        if (vm.watchlist.isEmpty) {
          return const Center(
            child: Text(
              StringConstants.noWatchlistFound,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.separated(
          itemCount: vm.watchlist.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          separatorBuilder: (_, __) => const Divider(
            color: ColorConstants.blackColor,
            thickness: 1,
            height: 1,
          ),
          itemBuilder: (context, index) {
            final stock = vm.watchlist[index];
            return _buildStockTile(context, stock);
          },
        );
      },
    );
  }

  Widget _buildStockTile(BuildContext context, SearchResultModel stock) {
    return GestureDetector(
      onTap: () => context.pushNamed(RouteConstants.stockDetailScreen, extra: {
        ParameterKeyConstants.stockName: stock.name,
        ParameterKeyConstants.stockSymbol: stock.symbol
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        clipBehavior: Clip.hardEdge,
        child: Slidable(
          key: ValueKey(stock.name),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.2,
            children: [
              CustomSlidableAction(
                onPressed: (_) {
                  _deleteStockBottomSheet(context: context, stock: stock);
                },
                backgroundColor: Colors.transparent,
                autoClose: true,
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.blackColor,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    stock.name ?? StringConstants.stockNameNotFound,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstants.whiteColor,
                        height: 1.4,
                        fontSize: 14),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      convertUsdToInr(stock.close),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getPriceColor(stock.close),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text("(${formatPercent(stock.percentChange)})",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getPercentColor(stock.percentChange),
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriceColor(String? percentChangeStr) {
    final percent = double.tryParse(percentChangeStr ?? '0.0') ?? 0.0;
    return percent >= 0
        ? ColorConstants.emeraldGreen
        : ColorConstants.crimsonRed;
  }

  Color _getPercentColor(String? percentChangeStr) {
    final percent = double.tryParse(percentChangeStr ?? '0.0') ?? 0.0;
    return percent >= 0 ? ColorConstants.greyText : ColorConstants.crimsonRed;
  }

  String convertUsdToInr(String? usdValue, {bool addSymbol = true}) {
    const double usdToInrRate = 83.21; // you can later make it dynamic
    final usd = double.tryParse(usdValue ?? '');
    if (usd == null) return '${addSymbol ? '₹' : ''}0.00';

    final inr = usd * usdToInrRate;
    final isPositive = inr >= 0;
    final prefix = isPositive ? '+' : '–';
    final absValue = inr.abs().toStringAsFixed(2);

    return '${addSymbol ? '₹' : ''}$prefix$absValue';
  }

  String formatPercent(String? percentChange) {
    final percent = double.tryParse(percentChange ?? '');
    if (percent == null) return '0.00%';

    final prefix = percent >= 0 ? '' : '–';
    return '$prefix${percent.abs().toStringAsFixed(2)}%';
  }

  void _deleteStockBottomSheet(
      {required BuildContext context, required SearchResultModel? stock}) {
    showCustomBottomSheet(
      context: context,
      title: StringConstants.deleteFromwatchList,
      description: StringConstants.followingStockDeleteText,
      content: stock?.name ?? StringConstants.unknownStock,
      istButton: CustomButton(
        text: StringConstants.deleteStock,
        onPressed: () async {
          final viewModel = context.read<SearchStockViewmodel>();

          if (stock?.symbol != null) {
            await viewModel.removeFromWatchlist(stock?.symbol ?? "");
          }
          if (context.mounted) {
            context.pop();
            showInformativeMessage(
                message: StringConstants.stockRemovedText,
                backgroundColor: ColorConstants.emeraldGreen);
          }
        },
        buttonColor: ColorConstants.blackColor,
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
