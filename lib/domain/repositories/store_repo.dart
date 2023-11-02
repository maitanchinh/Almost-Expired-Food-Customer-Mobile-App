import 'package:appetit/domain/models/store.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class StoreRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Store> getStoreByProductId(String? productId) async {
    try {
      var res = await apiClient.get('/api/stores/product/$productId');
      return Store.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}