import 'dart:developer';

import 'package:beyond_stock_app/core/constants/string_constants.dart';
import 'package:beyond_stock_app/core/data/data_source/api_endpoint_constants.dart';
import 'package:beyond_stock_app/core/utils/api_utils/api_exception_error_constants.dart';
import 'package:beyond_stock_app/core/utils/api_utils/api_exception_handler.dart';
import 'package:beyond_stock_app/widgets/common_helper_widgets/internet_checker.dart';
import 'package:dio/dio.dart';

class ApiService {
  ApiService._privateConstructor();

  // Single instance of APIUtils
  static final ApiService instance = ApiService._privateConstructor();
  const ApiService();

  Future<Response<dynamic>> makeApiRequest({
    required String method,
    required String endpoint,
    bool showInternetConnectionMessage = false,
    bool showSnackbarerror = true,
    String? parerType,
    int? connectTimeout,
    int? receiveTimeout,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic body,
    int retryCount = 3,
    Duration retryDelay = const Duration(seconds: 2),
    CancelToken? cancelToken,
    Map<String, dynamic>? extra,
  }) async {
    final dio = _configureDio(connectTimeout, receiveTimeout);

    final isConnected = await isNetworkAvailable();

    if (!isConnected) {
      throw showInternetConnectionMessage
          ? NetworkException.fromStatusCode(
              0, StringConstants.noInternetErrorMessage)
          : "";
    }

    return await _performRequestWithRetry(
      dio: dio,
      method: method,
      endpoint: endpoint,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      cancelToken: cancelToken,
      retryCount: retryCount,
      retryDelay: retryDelay,
      showSnackbarerror: showSnackbarerror,
    );
  }

  Dio _configureDio(int? connectTimeout, int? receiveTimeout) {
    final dio = DioClient.instance.dio;
    dio.options
      ..connectTimeout = Duration(seconds: connectTimeout ?? 20)
      ..receiveTimeout = Duration(seconds: receiveTimeout ?? 20);
    return dio;
  }

  Future<Response> _performRequestWithRetry({
    required Dio dio,
    required String method,
    required String endpoint,
    required Map<String, dynamic>? queryParameters,
    required dynamic body,
    required Map<String, dynamic>? headers,
    required CancelToken? cancelToken,
    required int retryCount,
    required Duration retryDelay,
    required bool showSnackbarerror,
  }) async {
    int attempt = 0;

    while (attempt < retryCount) {
      try {
        log('API URL: $endpoint');
        log('Query Params: $queryParameters');

        final response = await dio.request(
          endpoint,
          queryParameters: queryParameters,
          data: body,
          cancelToken: cancelToken,
          options: Options(
            method: method,
            headers: headers,
          ),
        );

        log("Request made to: ${response.requestOptions.baseUrl}${response.requestOptions.path}");

        return response;
      } on DioException catch (e) {
        await _handleDioError(
          e,
          attempt,
          retryCount,
          retryDelay,
          showSnackbarerror,
        );
        attempt++;
      }
    }

    throw ""; // fallback
  }

  Future<void> _handleDioError(
    DioException e,
    int attempt,
    int retryCount,
    Duration retryDelay,
    bool showSnackbarerror,
  ) async {
    if (CancelToken.isCancel(e)) {
      throw StringConstants.requestCancelledErrorMessage;
    }

    if (e.response?.statusCode == 401 &&
        e.response?.data['exception'] != null) {
      _handleSessionExpired();
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      if (attempt < retryCount - 1) {
        await Future.delayed(retryDelay);
      } else {
        throw NetworkException.fromStatusCode(
          600,
          ApiExceptionErrorConstants.connectionTimeoutError,
        );
      }
    } else {
      final errorMsg = e.response?.data?['message']?['message'] ??
          StringConstants.anUnExpectedErrorOccuredErrorMessage;

      if (showSnackbarerror) {
        throw NetworkException.fromStatusCode(
          e.response?.statusCode ?? 500,
          errorMsg,
        );
      } else {
        throw e.response?.statusCode ?? 0;
      }
    }
  }

  String _handleSessionExpired() {
    return ApiEndPointConstants.baseUrl;
  }
}

class DioClient {
  DioClient._privateConstructor();

  static final DioClient instance = DioClient._privateConstructor();

  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: ApiEndPointConstants.baseUrl,
  );

  static final Dio _dio = Dio(_baseOptions);

  Dio get dio => _dio;
}
