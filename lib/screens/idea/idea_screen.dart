import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class IdeaScreen extends StatelessWidget {
  const IdeaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.blackColor,
        appBar: CustomAppBar(
          backgroundColor: ColorConstants.blackColor,
          title: StringConstants.ideaScreen,
          fontSize: 16,
          showLeadingIcon: false,
          fontWeight: FontWeight.w600,
        ),
        body: Center(
          child: Text(
            StringConstants.ideaScreen,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 18,
                ),
          ),
        ));
  }
}
