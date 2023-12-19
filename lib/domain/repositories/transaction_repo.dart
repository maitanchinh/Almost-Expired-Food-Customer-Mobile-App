import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/transactions.dart';

class TransactionRepo {
  final Dio _apiclient = getIt<Dio>();

  Future<Transactions> getTransactions({String? status}) async {
    try {
      var res = await _apiclient.get('/api/transactions/customer', queryParameters: {'status' : status});
      return Transactions.fromJson(res.data);
    } on DioException catch (e) {
      print('Exception at get transactions: ' + e.response!.data);
      throw Exception(msg_server_error);
    }
  }
}