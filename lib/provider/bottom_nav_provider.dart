import 'package:beyond_stock_app/core/di/di_setup.dart';
import 'package:beyond_stock_app/view_model/bottom_nav_viewmodel.dart';
import 'package:provider/provider.dart';

class BottomNavProvider {
  static ChangeNotifierProvider<BottomNavViewmodel> provide() {
    return ChangeNotifierProvider<BottomNavViewmodel>(
      create: (context) => getIt<BottomNavViewmodel>(),
    );
  }
}
