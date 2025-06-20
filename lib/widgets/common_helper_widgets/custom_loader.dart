import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final String message;
  final Color loaderColor;
  final Color textColor;

  const CustomLoader({
    super.key,
    required this.message,
    this.loaderColor = Colors.white,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: loaderColor),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
