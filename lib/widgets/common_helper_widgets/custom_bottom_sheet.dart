import 'package:flutter/material.dart';
import 'custom_button.dart'; // make sure to import your custom button

void showCustomBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
  required String content,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1C1C1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: "Add Stock",
              onPressed: onConfirm,
              buttonColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.transparent,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: "Cancel",
              onPressed: onCancel,
              buttonColor: Colors.transparent,
              textColor: Colors.white,
              borderColor: Colors.white30,
            ),
          ],
        ),
      );
    },
  );
}
