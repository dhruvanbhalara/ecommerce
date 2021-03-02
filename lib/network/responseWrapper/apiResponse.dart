import 'package:dio/dio.dart';

class APIResponse {
  static final _tag = 'APIResponse';
  dynamic data;
  Headers headers;
  String dioErrorType;
  int statusCode;
  List<int> errors;

  APIResponse(this.data, this.statusCode, {this.headers, this.dioErrorType})
      : errors = headers != null && headers['errorKey'] != null
            ? [] // Decode errors to [errors]
            : null {
    //logger.i(this);
  }

  bool get isOk =>
      dioErrorType == null &&
      errors == null &&
      statusCode != null &&
      statusCode >= 200 &&
      statusCode < 400;

  bool get isNotOk => !isOk;

  @override
  String toString() =>
      '[$_tag] Code: $statusCode | Body: $data | Headers: $headers | Error: $dioErrorType';
}
