import 'package:beyond_stock_app/core/constants/color_constants.dart';
import 'package:beyond_stock_app/core/utils/api_utils/api_exception_error_constants.dart';
import 'package:beyond_stock_app/enums/api_exception_enum.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/snackbar.dart';
import 'package:flutter/material.dart';

abstract class ApiExceptionHandler implements Exception {
  final String message;
  final String? code;
  ApiExceptionHandler({required this.message, this.code});
}

class NetworkException extends ApiExceptionHandler {
  final int? statusCode;
  NetworkException({required super.message, this.statusCode, super.code});

  factory NetworkException.fromStatusCode(int statusCode, String errorMessage) {
    switch (statusCode) {
      case 400:
      case 417:
      case 409:
        _buildShowErrorMessage(
          errorMessage: errorMessage,
        );

        return NetworkException(
            message: ApiExceptionEnum.badRequest.name,
            statusCode: statusCode,
            code: ApiExceptionEnum.badRequest.name);

      case 401:
        _buildShowErrorMessage(
          errorMessage: errorMessage,
        );
        return NetworkException(
            message: ApiExceptionEnum.codeExpired.name,
            statusCode: statusCode,
            code: ApiExceptionEnum.codeExpired.name);
      case 403:
        _buildShowErrorMessage(
          errorMessage: errorMessage,
        );

        return NetworkException(
            message: ApiExceptionEnum.unauthorized.name,
            statusCode: statusCode,
            code: ApiExceptionErrorConstants.youDontHaveAcess);
      case 408:
        _buildShowErrorMessage(
          errorMessage: errorMessage,
        );
        return NetworkException(
            message: ApiExceptionEnum.requestTimeout.name,
            statusCode: statusCode,
            code: ApiExceptionErrorConstants.requestTimeoutError);
      case 600:
        _buildShowErrorMessage(
          errorMessage: errorMessage,
        );
        return NetworkException(
            message: ApiExceptionEnum.connectionTimeout.name,
            statusCode: statusCode,
            code: ApiExceptionErrorConstants.connectionTimeoutError);
      case 0:
        _buildShowErrorMessage(
          errorMessage: errorMessage,
        );
        return NetworkException(
            message: ApiExceptionEnum.connectionTimeout.name,
            statusCode: statusCode,
            code: ApiExceptionErrorConstants.connectionTimeoutError);
      default:
        _buildShowErrorMessage(
          errorMessage: statusCode == 500 && errorMessage != ""
              ? errorMessage
              : ApiExceptionErrorConstants.internalServerError,
        );
        return NetworkException(
            message: ApiExceptionEnum.internalServerError.name,
            statusCode: statusCode,
            code: ApiExceptionErrorConstants.pleaseTryAgainLater);
    }
  }

  static Widget _buildShowErrorMessage({required String errorMessage}) {
    return showInformativeMessage(
       // bottomMargin: 20.0,
        message: errorMessage,
        // fontSize: 14,
        // backgroundColor: ColorConstants.crimsonRed,
        // textColor: ColorConstants.whiteColor
        );
  }
}
