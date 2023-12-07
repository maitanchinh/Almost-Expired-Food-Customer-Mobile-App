import 'package:appetit/domain/models/cart.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class CartRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Cart> getCart() async {
    try {
      var res = await apiClient.get('/api/carts');
      return Cart.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> addToCart({required String productId, required int quantity}) async {
    try {
      var res = await apiClient.post('/api/carts', data: {'productId' : productId, 'quantity' : quantity});
      return res.statusCode!;
    } on DioException catch(e){
      print(e);
      if (e.response!.statusCode == 409) {
        throw Exception(msg_exceed_quantity);
      }
      throw Exception(msg_server_error);
    }
  }

  Future<CartItem> updateCart(String? itemId, int? quantity) async {
    try {
      var res = await apiClient.put('/api/carts/items/$itemId', data: {"quantity" : quantity});
      return CartItem.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> removeCartItem({required String itemId}) async {
    try {
      var res = await apiClient.delete('/api/carts/items/$itemId');
      return res.statusCode!;
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}