import 'package:appetit/domain/models/account.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class AccountRepo {
  final Dio _apiClient = getIt.get<Dio>();
  static Account? account;
  Future<Account> getAccountInformation() async {
    try {
      var res = await _apiClient.get('/api/customers/information');
      account = Account.fromJson(res.data);
      return Account.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> updateProfile({String? name, String? phone}) async {
    try {
      var res = await _apiClient.put('/api/customers', data: {'name': name, 'phone' : phone});
      return res.statusCode!;
    } on DioException catch (e) {
      print('Exception at Update Profile: ' + e.response!.data.toString());
      throw Exception(msg_server_error);
    }
  }
}