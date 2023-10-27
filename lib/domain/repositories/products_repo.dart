import 'package:appetit/domain/models/products.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../../utils/get_it.dart';

class ProductsRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Products> getProductsByCategory(String categoryId) async {
    try {
      var res = await apiClient.get('/api/products?categoryId=$categoryId');
      return Products.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}
