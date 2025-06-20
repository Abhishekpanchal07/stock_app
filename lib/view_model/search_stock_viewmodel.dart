import 'dart:async';
import 'dart:developer';
import 'package:beyond_stock_app/modals/search_result_model.dart';
import 'package:beyond_stock_app/repository/search_stock_api_service.dart';
import 'package:flutter/material.dart';

/* class SearchStockViewmodel extends ChangeNotifier {
  List<SearchResultModel> searchResultList = [];
  bool _showProgressLoader = false;
  bool get showProgressLoader => _showProgressLoader;

  final searchStockApiService = SearchStockApiService();

  Timer? _debounce;

  void onSearchTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        await searchStock(query: query);
      } else {
        searchResultList.clear();
        notifyListeners();
      }
    });
  }

  Future<void> searchStock({required String query}) async {
    _showProgressLoader = true;
    notifyListeners();
    try {
      searchResultList = await searchStockApiService.searchStock(query: query);

      notifyListeners();
    } catch (e) {
      // handle error or show message
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
 */
class SearchStockViewmodel extends ChangeNotifier {
  List<SearchResultModel> searchResultList = [];
  bool _showProgressLoader = false;
  bool get showProgressLoader => _showProgressLoader;

  bool _hasSearched = false;
  bool get hasSearched => _hasSearched;

  final searchStockApiService = SearchStockApiService();

  Timer? _debounce;

  void onSearchTextChanged(String query) {
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
