import 'package:beyond_stock_app/core/di/di_setup.dart';
import 'package:beyond_stock_app/view_model/search_stock_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchStockProvider {
  static ChangeNotifierProvider<SearchStockViewmodel> provide() {
    return ChangeNotifierProvider<SearchStockViewmodel>(
      create: (context) => getIt<SearchStockViewmodel>(),
      // child: const BottomNavigation(),
    );
  }
}
