import 'package:beyond_stock_app/modals/bottom_nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/string_constants.dart';
import '../../../view_model/bottom_nav_viewmodel.dart';
import '../../../widgets/common_helper_widgets/svg_image.dart';

class CustomBottomNavItem extends StatelessWidget {
  final BottomNavItemModel item;
  final int index;

  const CustomBottomNavItem({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<BottomNavViewmodel>().selectedIndex;
    final isSelected = selectedIndex == index;
    final provider = context.read<BottomNavViewmodel>();

    return GestureDetector(
      onTap: () => provider.changeIndex(index),
      child: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorConstants.addButtonColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  SvgImage(
                    imagePath: item.icon,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontFamily: StringConstants.fontFamily,
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          : SvgImage(
              imagePath: item.icon,
              width: 20,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
    );
  }
}
