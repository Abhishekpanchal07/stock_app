import 'package:beyond_stock_app/app_theme/app_theme.dart';
import 'package:beyond_stock_app/core/constants/provider_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/di/di_setup.dart';
import 'package:beyond_stock_app/screens/add_stock/screen/add_stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() {
  setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstants.appName,
        theme: AppTheme.darkTheme,
        home: const AddStock(),
      ),
    );
  }
}
