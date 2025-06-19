import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        cursorColor: ColorConstants.searchStockColor,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: StringConstants.searchStock,
          hintStyle: TextStyle(
              color: ColorConstants.searchStockColor,
              fontSize: 14,
              fontFamily: StringConstants.fontFamily),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
