import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;

  const CustomButton({
    super.key,
    required this.text,
     this.onPressed,
    this.buttonColor = Colors.white,
    this.textColor = Colors.black,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: buttonColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
