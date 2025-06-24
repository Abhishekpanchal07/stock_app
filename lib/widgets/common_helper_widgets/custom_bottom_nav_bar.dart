import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:beyond_stock_app/modals/bottom_nav_item_model.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_bottom_nav_item.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BottomNavItemModel> items = [
      BottomNavItemModel(
        icon: SvgImageConstants.bottomNavStockIcon,
        label: StringConstants.stocks,
      ),
      BottomNavItemModel(
        icon: SvgImageConstants.bottomNavNoteIcon,
        label: StringConstants.notes,
      ),
      BottomNavItemModel(
        icon: SvgImageConstants.bottomNavIdeaIcon,
        label: StringConstants.ideas,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => CustomBottomNavItem(
            item: items[index],
            index: index,
          ),
        ),
      ),
    );
  }
}
