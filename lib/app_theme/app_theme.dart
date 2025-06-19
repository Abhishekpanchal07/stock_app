import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorConstants.scaffoldBgColor,
      primaryColor: ColorConstants.accentColor,
      fontFamily:StringConstants.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorConstants.bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          fontFamily:StringConstants.fontFamily,
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.scaffoldBgColor,
        selectedItemColor: ColorConstants.accentColor,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 24),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorConstants.accentColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily:StringConstants.fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: ColorConstants.textColor,
        ),
        headlineSmall: TextStyle(
          fontFamily:StringConstants.fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: ColorConstants.textColor,
        ),
        bodyMedium: TextStyle(
          fontFamily:StringConstants.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: ColorConstants.textColor,
        ),
        bodySmall: TextStyle(
          fontFamily:StringConstants.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: ColorConstants.textColor,
        ),
      ),
      dividerColor: Colors.grey.shade800,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
