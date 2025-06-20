import 'dart:developer';

import 'package:beyond_stock_app/core/data/data_source/api_endpoint_constants.dart';
import 'package:beyond_stock_app/core/data/data_source/api_service.dart';
import 'package:beyond_stock_app/enums/api_request_enum.dart';
import 'package:beyond_stock_app/modals/search_result_model.dart';

class SearchStockApiService {
  // Private constructor
  SearchStockApiService._privateConstructor();

  // Singleton instance
  static final SearchStockApiService _instance =
      SearchStockApiService._privateConstructor();

  // Factory constructor to return the same instance
  factory SearchStockApiService() => _instance;

  // ApiService instance
  final ApiService apiService = const ApiService();

  Future<SearchResultModel?> searchStock({required String query}) async {
    try {
      final response = await apiService.makeApiRequest(
        method: ApiRequestEmun.get.name,
        endpoint: ApiEndPointConstants.searchEndPoint,
        queryParameters: {
          "symbol": query,
          "apikey": ApiEndPointConstants.apiKey,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        // Check for API error inside the 200 response
        if (data is Map &&
            data.containsKey('status') &&
            data['status'] == 'error') {
          log("API returned error: ${data['message']}");
          return null;
        }

        final responseData = SearchResultModel.fromJson(data);
        log("Stock search result: $responseData");
        return responseData;
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
