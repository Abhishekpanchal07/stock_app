import 'package:beyond_stock_app/core/di/di_setup.dart';
import 'package:beyond_stock_app/view_model/connectivity_viewmodel.dart';
import 'package:provider/provider.dart';

class ConnectivityProvider {
  static ChangeNotifierProvider<ConnectivityViewmodel> provide() {
    return ChangeNotifierProvider<ConnectivityViewmodel>(
      create: (context) => getIt<ConnectivityViewmodel>(),
    );
  }
}
