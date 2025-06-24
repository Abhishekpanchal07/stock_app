import 'package:beyond_stock_app/app_theme/app_theme.dart';
import 'package:beyond_stock_app/core/constants/provider_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/di/di_setup.dart';
import 'package:beyond_stock_app/routes/my_routes.dart';
import 'package:beyond_stock_app/services/hive/hive_manager.dart';
import 'package:beyond_stock_app/services/hive/register_hiveadapter.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Fixes Two issues in watchList Screen
// ist is correct the shape of delete icon container
// second when one is already slidable and user slide other ist will be unslidable

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveManager = HiveManager();
  await hiveManager.initHive();
  await registerAdapters(); 
  // Initialize the router asynchronously
  final router = await MyRoutes.initializeRouter();
  setUpLocator();
  runApp( MyApp(router: router,));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: StringConstants.appName,
        theme: AppTheme.darkTheme,
        routerConfig: router,
         builder: BotToastInit(), // ✅ This is correct
        // ⬆️ This works because BotToastInit() returns a valid TransitionBuilder
        // It's a function: (BuildContext context, Widget? child) => Widget
       
      ),
    );
  }
}
