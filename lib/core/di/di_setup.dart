import 'package:beyond_stock_app/view_model/bottom_nav_viewmodel.dart';
import 'package:beyond_stock_app/view_model/connectivity_viewmodel.dart';
import 'package:beyond_stock_app/view_model/search_stock_viewmodel.dart';
import 'package:beyond_stock_app/view_model/stock_detail_viewmodel.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setUpLocator() {
  getIt.registerLazySingleton<SearchStockViewmodel>(
      () => SearchStockViewmodel());
  getIt.registerLazySingleton<BottomNavViewmodel>(() => BottomNavViewmodel());
  getIt.registerLazySingleton<StockDetailViewmodel>(
      () => StockDetailViewmodel()); 
      getIt.registerLazySingleton<ConnectivityViewmodel>(
      () => ConnectivityViewmodel());
}
