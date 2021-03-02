import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:ecommerce/helper/constant/constant.dart';
import 'package:ecommerce/helper/enum.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'constants/endPoints.dart';
import 'exceptions/dioErrorutil.dart';
import 'interceptor/internetInterceptor.dart';
import 'responseWrapper/apiResponse.dart';

/// Main APIService
///
/// This will create a singleton instance
///
class APIService {
  static APIService _apiService = APIService._();
  static Dio _client;
  static bool _initialized = false;

  static APIService get api => _apiService;

  APIService._();

  @visibleForTesting
  set setMockInstance(APIService instance) => _apiService = instance;

  void init() async {
    if (!_initialized) {
      _client = Dio();
      _client.options.baseUrl = kBaseUrl;
      _client.options.connectTimeout = 10000;
      _client.options.headers.addAll({
        "Accept": "application/json",
        "token": "$kAuthToken",
      });
      _client.interceptors.add(DioCacheManager(CacheConfig()).interceptor);
      _client.interceptors.add(InternetInterceptors(_client));

      if (!kReleaseMode)
        _client.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 150,
          ),
        );
      _initialized = true;
    }
  }

  Future<APIResponse> _performRequest(
    RequestType type,
    String resource, {
    Map<String, dynamic> headers,
    Map<String, dynamic> queryParams,
    Map<String, dynamic> body,
    FormData formData,
  }) async {
    if (!_initialized) {
      init();
    }

    Response response;

    if (headers != null) {
      _client.options.headers.addAll(headers);
    }

    queryParams?.removeWhere((k, v) => v == null);

    try {
      switch (type) {
        case RequestType.get:
          response = await _client.get(resource, queryParameters: queryParams);
          break;
        case RequestType.post:
          response = await _client.post(resource, data: formData == null ? queryParams : formData);
          break;
      }
      return APIResponse(
        response?.data,
        response?.statusCode,
        headers: response?.headers,
        dioErrorType: response?.statusMessage == "OK" ? null : response?.statusMessage,
      );
    } on DioError catch (e) {
      return APIResponse(
        e.response?.data,
        e.response?.statusCode,
        headers: e.response?.headers,
        dioErrorType: DioErrorUtil.handleError(e),
      );
    }
  }

  /// Product list API
  Future<APIResponse> fetchProductList({int page}) async {
    return await _performRequest(
      RequestType.post,
      EndPoints.productList,
      queryParams: {
        "page": page,
        "perPage": kPageItems,
      },
    );
  }
}
