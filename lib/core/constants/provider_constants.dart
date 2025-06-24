import 'package:beyond_stock_app/provider/bottom_nav_provider.dart';
import 'package:beyond_stock_app/provider/connectivity_provider.dart';
import 'package:beyond_stock_app/provider/search_stock_provider.dart';
import 'package:beyond_stock_app/provider/stock_detail_provider.dart';

final providers = [
  SearchStockProvider.provide(),
  BottomNavProvider.provide(),
  StockDetailProvider.provide(),
  ConnectivityProvider.provide(),
];
