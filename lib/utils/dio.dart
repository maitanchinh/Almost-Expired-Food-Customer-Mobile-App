import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AConstants.dart';

final apiClient = Dio()..options.baseUrl = API_URL..options.headers = {
  'Content-Type': 'application/json-patch+json',
    'Accept': 'text/plain',
}..interceptors.addAll([
  InterceptorsWrapper(
    onRequest: (request, handler) async {
      var token = getStringAsync(TOKEN_KEY);
      if (token.isNotEmpty) {
        request.headers['Authorization'] = token;
      }
      return handler.next(request);
    }
  )
]);