import 'package:appetit/domain/models/account.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class AccountRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Account> getAccountInformation() async {
    try {
      var res = await apiClient.get('/api/customers/information');
      return Account.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}