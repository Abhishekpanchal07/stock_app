import 'package:beyond_stock_app/widgets/common_helper_widgets/animated_bottom_sheet.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_button.dart';
import 'package:flutter/material.dart';


  void showCustomBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
  required String content,
  // required VoidCallback onConfirm,
  // required VoidCallback onCancel,
  required Widget istButton,
  required CustomButton secondButton,

}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1C1C1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return AnimatedBottomSheetContent(
        title: title,
        description: description,
        content: content,
        // onConfirm: onConfirm,
        // onCancel: onCancel,
        istButton: istButton,
        secondButton: secondButton,
      );
    },
  );
}

