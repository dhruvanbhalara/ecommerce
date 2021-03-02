import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class InternetInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  InternetInterceptors(this._dio);

  @override
  onRequest(RequestOptions options) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return _dio.resolve(Response(data: null, statusCode: -1, statusMessage: 'No Internet Connection'));
    }
    return options;
  }
}
