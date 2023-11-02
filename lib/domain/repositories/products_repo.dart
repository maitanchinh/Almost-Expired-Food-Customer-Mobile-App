import 'package:appetit/domain/models/products.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../../utils/get_it.dart';

class ProductsRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Products> getProducts(String? categoryId, String? campaignId,
      String? name, bool? isPriceHighToLow, bool? isPriceLowToHight) async {
    try {
      var res = await apiClient.get('/api/products', queryParameters: {
        'categoryId': categoryId,
        'campaignId': campaignId,
        'name': name,
        'isPriceHighToLow': isPriceHighToLow,
        'isPriceLowToHight': isPriceLowToHight
      });
      return Products.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  // Future<Products> getProductsByCampaignId(String campaignId) async {
  //   try {
  //     var res = await apiClient.get('/api/products?campaignId=$campaignId');
  //     return Products.fromJson(res.data);
  //   } on DioException {
  //     throw Exception(msg_server_error);
  //   }
  // }
}
