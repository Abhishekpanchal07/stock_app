import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/main.dart';
import 'package:flutter/material.dart';

/* showInformativeMessage({
  required String message,
  Color backgroundColor = ColorConstants.crimsonRed,
  Color textColor = ColorConstants.whiteColor,
  double bottomMargin = 20.0,
  double fontSize = 14.0,
  double borderRadius = 30.0,
  FontWeight fontweight = FontWeight.w400,
}) {
  final snackBar = SnackBar(
    content: Center(
        child: Text(
      message,
      style: TextStyle(
          color: textColor,
          fontSize:
              fontSize, //The text size is fixed for snackbar messages if creating issue we will do it individually.
          fontFamily: StringConstants.fontFamily,
          fontWeight: fontweight),
    )),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating, // Allows custom positioning
    // margin: EdgeInsets.only(
    //   bottom: bottomMargin, // 100px from the top
    //   // left: 16.0,
    //   // right: 16.0,
    // ),

    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(
        // borderRadius:
        //     BorderRadius.circular(borderRadius), // Apply circular radius
        ), // Duration of the SnackBar
  );

  // Display the SnackBar
  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}  */

 showInformativeMessage({
  required String message,
  Color? color = ColorConstants.crimsonRed,
}) {
  final overlay = Overlay.of(
    scaffoldMessengerKey.currentState!.context,
    rootOverlay: true, // 🔥 this line is key
  );

  if (overlay == null) return;

  final entry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Material(
        elevation: 10,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color ?? Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(Duration(seconds: 3)).then((_) => entry.remove());
}


