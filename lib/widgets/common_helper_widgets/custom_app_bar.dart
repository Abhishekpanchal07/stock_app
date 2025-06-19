import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/svg_image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomAppBar(
      {super.key, required this.title, this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: ColorConstants.scaffoldBgColor, // Use your scaffold color
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(12), // centers the icon (24x24)
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F), // Adjust as per your design
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SvgPicture.asset(
                  SvgImageConstants.backIcon,
                  height: 24,
                  width: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize ?? 20,
                fontWeight: fontWeight ?? FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(72); // Adjust height as needed
}
