import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final ColorFilter? colorFilter;

  const SvgImage(
      {super.key,
      required this.imagePath,
      this.height,
      this.width,
      this.colorFilter});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      height: height ?? 0.0,
      width: width ?? 0.0,
      colorFilter: colorFilter,
    );
  }
}
