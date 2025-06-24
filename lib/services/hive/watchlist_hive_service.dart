import 'dart:developer';

import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/modals/search_result_model.dart';
import 'package:beyond_stock_app/services/hive/hive_box_names.dart';
import 'package:beyond_stock_app/services/hive/hive_manager.dart';

class WatchlistHiveService {
  final HiveManager _hiveManager = HiveManager();

  /// Add or update stock in the watchlist.
  /// Returns a message indicating the result.
  Future<String> addOrUpdateToWatchlist(SearchResultModel model) async {
    if (model.symbol == null) return 'Invalid stock data.';

    final box =
        await _hiveManager.getBox<SearchResultModel>(HiveBoxNames.watchlistBox);
    final alreadyExists = box.containsKey(model.symbol);

    await box.put(model.symbol, model); // ✅ STORE or UPDATE

    return alreadyExists
        ? StringConstants.stockUpdatedText
        : StringConstants.stockAddedText;
  }

  Future<void> removeFromWatchlist(String symbol) async {
    final box =
        await _hiveManager.getBox<SearchResultModel>(HiveBoxNames.watchlistBox);
    if (box.containsKey(symbol)) {
      await box.delete(symbol);
      log("Stock with symbol '$symbol' removed from watchlist.");
    } else {
      log("No stock found with symbol '$symbol' in the watchlist.");
    }
  }

  Future<List<SearchResultModel>> getAllWatchlistItems() async {
    final box =
        await _hiveManager.getBox<SearchResultModel>(HiveBoxNames.watchlistBox);
    return box.values.toList();
  }

  Future<void> clearWatchlist() async {
    final box =
        await _hiveManager.getBox<SearchResultModel>(HiveBoxNames.watchlistBox);
    await box.clear();
  }
}
