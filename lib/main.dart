import 'package:beyond_stock_app/app_theme/app_theme.dart';
import 'package:beyond_stock_app/core/constants/global_key_constants.dart';
import 'package:beyond_stock_app/core/constants/provider_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/di/di_setup.dart';
import 'package:beyond_stock_app/routes/my_routes.dart';
import 'package:beyond_stock_app/services/hive/hive_manager.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveManager = HiveManager();
  await hiveManager.initializeHive();
  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: StringConstants.appName,
        theme: AppTheme.darkTheme,
        routerConfig: MyRoutes.router,
        builder: BotToastInit(),
      ),
    );
  }
}
