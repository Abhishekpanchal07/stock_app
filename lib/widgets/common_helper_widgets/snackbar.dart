import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';

showInformativeMessage({
  required String message,
  Color backgroundColor = ColorConstants.crimsonRed,
  Color textColor = ColorConstants.whiteColor,
  Duration duration = const Duration(seconds: 3),
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
}) {
  BotToast.showCustomText(
    duration: duration,
    onlyOne: true,
    crossPage: true,
    toastBuilder: (_) => Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: StringConstants.fontFamily,
          ),
        ),
      ),
    ),
  );
}

void showOfflineMessage() {
  showInformativeMessage(
    message: StringConstants.youAreOfflinePleaseConnect,
    fontSize: 12.0,
  );
}

void showBackOnlineMessage() {
  showInformativeMessage(
    message: StringConstants.backOnlineMessage, // Inspired by YouTube
    fontSize: 12.0,
    backgroundColor: ColorConstants.emeraldGreen,
  );
}
