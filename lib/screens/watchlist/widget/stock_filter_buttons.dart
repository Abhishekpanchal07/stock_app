import 'package:flutter/material.dart';
import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/svg_image.dart';

class SortFilterButtons extends StatelessWidget {
  const SortFilterButtons({
    super.key,
  });

  Widget _buildButton(
      {required String title,
      required String imagePath,
      required bool iconBeforeText,
      required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorConstants.blackColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorConstants.scaffoldBgColor),
      ),
      child: Row(
        children: iconBeforeText
            ? [
                SvgImage(imagePath: imagePath, height: 7, width: 11),
                const SizedBox(width: 5),
                Text(title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstants.scaffoldBgColor, fontSize: 13)),
              ]
            : [
                Text(title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstants.scaffoldBgColor, fontSize: 13)),
                const SizedBox(width: 5),
                SvgImage(imagePath: imagePath, height: 7, width: 11),
              ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
            title: StringConstants.sort,
            imagePath: SvgImageConstants.sortIcon,
            context: context,
            iconBeforeText: false),
        _buildButton(
            title: StringConstants.dayChange,
            imagePath: SvgImageConstants.dayChangeIcon,
            context: context,
            iconBeforeText: true),
      ],
    );
  }
}
