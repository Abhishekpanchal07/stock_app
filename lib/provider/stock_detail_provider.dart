import 'package:beyond_stock_app/core/di/di_setup.dart';
import 'package:beyond_stock_app/view_model/stock_detail_viewmodel.dart';
import 'package:provider/provider.dart';

class StockDetailProvider {
  static ChangeNotifierProvider<StockDetailViewmodel> provide() {
    return ChangeNotifierProvider<StockDetailViewmodel>(
      create: (context) => getIt<StockDetailViewmodel>(),
      // child: const BottomNavigation(),
    );
  }
}
