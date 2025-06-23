import 'dart:developer';
import 'package:beyond_stock_app/core/data/data_source/api_endpoint_constants.dart';
import 'package:beyond_stock_app/core/data/data_source/api_service.dart';
import 'package:beyond_stock_app/enums/api_request_enum.dart';
import 'package:beyond_stock_app/modals/benchmark_model.dart';
import 'package:beyond_stock_app/modals/time_series_model.dart';
import 'package:flutter/foundation.dart';

class TimeSeriesApiService {
  TimeSeriesApiService._privateConstructor();
  static final TimeSeriesApiService _instance =
      TimeSeriesApiService._privateConstructor();

  factory TimeSeriesApiService() => _instance;

  // ApiService instance
  final ApiService apiService = const ApiService();
  TimeSeriesModel parseTimeSeriesModel(Map<String, dynamic> json) {
    return TimeSeriesModel.fromJson(json);
  }

  BenchmarkModel parseBenchmarkModel(Map<String, dynamic> json) {
    return BenchmarkModel.fromJson(json);
  }

  Future<TimeSeriesModel?> fetchStockDetail(
      {required String stockSymbol}) async {
    try {
      final response = await apiService.makeApiRequest(
        method: ApiRequestEmun.get.name,
        endpoint: ApiEndPointConstants.timeSeriesEndPoint,
        queryParameters: {
          "symbol": stockSymbol,
          "interval": "1day",
          "output": "5000",
          "apikey": ApiEndPointConstants.apiKey,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data is Map &&
            data.containsKey('status') &&
            data['status'] == 'error') {
          log("API returned error: ${data['message']}");
          return null;
        }

        final result = await compute<Map<String, dynamic>, TimeSeriesModel>(
          parseTimeSeriesModel,
          data as Map<String, dynamic>,
        );
        log("Time series Parsed Data$result");
        return result;
      } else {
        log("Unexpected status code: ${response.statusCode}");
        return null;
      }
    } catch (e, stacktrace) {
      log("Error occurred while fetching stock: $e");
      log("Stacktrace: $stacktrace");
      return null;
    }
  }

  Future<BenchmarkModel?> fetchBenchmarkDetail() async {
    try {
      final response = await apiService.makeApiRequest(
        method: ApiRequestEmun.get.name,
        endpoint: ApiEndPointConstants.timeSeriesEndPoint,
        queryParameters: {
          "symbol": "SPY",
          "interval": "1day",
          "output": "5000",
          "apikey": ApiEndPointConstants.apiKey,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data is Map &&
            data.containsKey('status') &&
            data['status'] == 'error') {
          log("API returned error: ${data['message']}");
          return null;
        }

        final result = await compute<Map<String, dynamic>, BenchmarkModel>(
          parseBenchmarkModel,
          data as Map<String, dynamic>,
        );
        log("Benchmark Parsed Data$result");
        return result;
      } else {
        log("Unexpected status code: ${response.statusCode}");
        return null;
      }
    } catch (e, stacktrace) {
      log("Error occurred while fetching stock: $e");
      log("Stacktrace: $stacktrace");
      return null;
    }
  }
}
