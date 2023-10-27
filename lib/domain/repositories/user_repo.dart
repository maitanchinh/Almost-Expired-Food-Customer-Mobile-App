import 'package:appetit/utils/AConstants.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJhNDFiM2ZlLWIyOTYtNDkyOC1iZDRiLTk5ZTQwMmFkYmU0NyIsInJvbGUiOiJDdXN0b21lciIsIm5iZiI6MTY5NzYyNDU2MywiZXhwIjoxNjk4MjI5MzYzLCJpYXQiOjE2OTc2MjQ1NjN9.mFJ2PaE9EkqNRgg6qJKXG4IRN0c-ljiGqeeHf_8glmE
class UserRepo{
  final Dio apiClient = getIt.get<Dio>();

  Future<void> login({required String idToken}) async{
     try {
      var res = await apiClient.post('/api/auth/google/customer', data: {'idToken': idToken});
       var accessToken = res.data['accessToken'] as String?;
       if (accessToken == null || accessToken.isEmpty) {
         throw Exception(msg_login_token_invalid);
       }
       await setValue(TOKEN_KEY, accessToken);
     } on DioException catch (e) {
       if (e.response!.statusCode == 401) {
         throw Exception(msg_login_by_google_failed_title);
       }
       throw Exception(msg_server_error);
     }
  }
}