import 'dart:async';
import 'dart:developer';
import 'package:beyond_stock_app/modals/search_result_model.dart';
import 'package:beyond_stock_app/repository/search_stock_api_service.dart';
import 'package:beyond_stock_app/services/hive/watchlist_hive_service.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/internet_checker.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/snackbar.dart';
import 'package:flutter/material.dart';

class SearchStockViewmodel extends ChangeNotifier {
  List<SearchResultModel> searchResultList = [];
  bool _showProgressLoader = false;
  bool get showProgressLoader => _showProgressLoader;

  bool _hasSearched = false;
  bool get hasSearched => _hasSearched;

  final searchStockApiService = SearchStockApiService();

  Timer? _debounce;
  final _watchlistService = WatchlistHiveService();

  List<SearchResultModel> _watchlist = [];
  List<SearchResultModel> get watchlist => _watchlist;

  bool _isWatchlistLoading = true;
  bool get isWatchlistLoading => _isWatchlistLoading; 

  String _searchText = '';
String get searchText => _searchText;

  Future<void> loadWatchlist() async {
    _isWatchlistLoading = true;
    notifyListeners();

    _watchlist = await _watchlistService.getAllWatchlistItems();

    _isWatchlistLoading = false;
    notifyListeners();
  } 

  void clearSearch() {
  _searchText = '';
  searchResultList.clear();
  _hasSearched = false;
  notifyListeners();
}

  /// Add or update stock in Hive watchlist
  Future<String> addToWatchlist(SearchResultModel model) async {
    final msg = await _watchlistService.addOrUpdateToWatchlist(model);
    await loadWatchlist(); // Auto-refresh the watchlist
    return msg;
  }

  /// Remove a stock from Hive
  Future<void> removeFromWatchlist(String symbol) async {
    await _watchlistService.removeFromWatchlist(symbol);
    final index = _watchlist.indexWhere((stock) => stock.symbol == symbol);
    if (index != -1) {
      _watchlist.removeAt(index);
      log("after removes an stock from list $_watchlist");
      notifyListeners();
    }
    await loadWatchlist();
  }

  /* void onSearchTextChanged(String query) { 
    _searchText = query;
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        _hasSearched = true;
        await searchStock(query: query);
      } else {
        _hasSearched = false;
        searchResultList.clear();
        notifyListeners();
      }
    }); 
    notifyListeners();
  } */ 

 void onSearchTextChanged(String query) {
  _searchText = query;
  notifyListeners(); // This makes sure UI (like close icon) updates immediately

  _debounce?.cancel();

  _debounce = Timer(const Duration(milliseconds: 500), () async {
    if (query.isNotEmpty) {
      final isConnected = await isNetworkAvailable(); // check inside debounce

      if (!isConnected) {
        showOfflineMessage(); // show toast/snackbar
        return;
      }

      _hasSearched = true;
      await searchStock(query: query);
    } else {
      _hasSearched = false;
      searchResultList.clear();
      notifyListeners();
    }
  });
}


  Future<void> searchStock({required String query}) async {
    _showProgressLoader = true;
    notifyListeners();

    try {
      searchResultList.clear();

      final results = await searchStockApiService.searchStock(query: query);
      if (results != null) {
        searchResultList.add(results);
      } else {
        _hasSearched = true;
        notifyListeners();
      }

      log("SearchList after Response :$searchResultList");
      notifyListeners();
    } catch (e) {
      log("Error Occurred when fetching stock:$e");
      // handle error
    } finally {
      _showProgressLoader = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
