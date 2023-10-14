import 'package:appetit/utils/AConstants.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepo{
  final Dio apiClient = getIt.get<Dio>();

  Future<void> login({required String idToken}) async{
    print(idToken);
     try {

       var requestBody = {'idToken': idToken};
       var response = await http.post(
         Uri.parse('https://expiredfood.azurewebsites.net/api/auth/google/customer'),
         body: jsonEncode(requestBody),
         headers: {
           'Content-Type': 'application/json',
           // Add any additional headers if needed
         },
       );

       print(response.body);

       // await apiClient.post('/api/auth/google/customer', data: {'idToken': idToken});
       //
       //
       // print("called");
       // var accessToken = res.data['accessToken'] as String?;
       // if (accessToken == null || accessToken.isEmpty) {
       //   throw Exception(msg_login_token_invalid);
       // }
       // print('Access Token: ' + accessToken);
       // await setValue(TOKEN_KEY, accessToken);
     } on DioException catch (e) {
       if (e.response!.statusCode == 401) {
         print(e.stackTrace);
         throw Exception(msg_login_by_google_failed_title);
       }
       print(e.message);
       throw Exception(msg_server_error);
     }
  }
}