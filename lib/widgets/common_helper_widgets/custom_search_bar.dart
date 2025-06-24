import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/view_model/search_stock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchStockViewmodel>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: ColorConstants.searchStockColor,
              style: const TextStyle(color: Colors.white),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: StringConstants.searchStock,
                hintStyle: TextStyle(
                  color: ColorConstants.searchStockColor,
                  fontSize: 14,
                  fontFamily: StringConstants.fontFamily,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (vm.searchText.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged(''); // triggers onSearchTextChanged and clears list
              },
              child: const Icon(Icons.close, color: Colors.white70),
            ),
        ],
      ),
    );
  }
}
