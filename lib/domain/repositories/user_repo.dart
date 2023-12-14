import 'package:appetit/utils/Constants.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

class UserRepo {
  final Dio apiClient = getIt.get<Dio>();
  Future<void> login({required String idToken}) async {
    try {
      var res = await apiClient.post('/api/auth/google/customer', data: {'idToken': idToken});
      var accessToken = res.data['accessToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception(msg_login_token_invalid);
      }
      await setValue(AppConstant.TOKEN_KEY, accessToken);
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        throw Exception(msg_login_by_google_failed_title);
      }
      throw Exception(msg_server_error);
    }
  }

  Future<void> sendDeviceToken() async {
    var deviceToken = getStringAsync(AppConstant.DEVICE_TOKEN);
    try {
      await apiClient.post('/api/device-tokens/customers', data: {'deviceToken': deviceToken});
    } on DioException catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
