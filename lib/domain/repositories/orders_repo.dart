import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/order/orders.dart';

class OrdersRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<int> createOrder(CreateOrder data) async {
    try {
      var res = await apiClient.post('/api/orders', data: {
        'paymentMethod': data.paymentMethod,
        'orderDetails': data.orderDetails?.map((orderDetail) => orderDetail.toJson()).toList()
      });
      return res.statusCode!;
    } on DioException catch (e){
      print(e);
      throw Exception(msg_server_error);
    }
  }

  Future<Orders> getOrdersList({String? status, bool? isPayment}) async {
    try {
      var res = await apiClient.get('/api/orders/customers', queryParameters: {'status' : status, 'isPayment' : isPayment} );
      return Orders.fromJson(res.data);
    } on DioException catch (e) {
      print(e);
      throw Exception(msg_server_error);
    }
  }

  Future<Order> getOrderById({required String orderId}) async {
    try {
      var res = await apiClient.get('/api/orders/$orderId');
      return Order.fromJson(res.data);
    } on DioException catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<String> payment({required int amount, required String orderId}) async {
    try {
      var res = await apiClient.post('/api/payments/request', data: {'amount' : amount, 'orderId' : orderId});
      return res.data;
    } on DioException catch (e) {
      print(e);
      throw Exception(msg_server_error);
    }
  }

  Future<int> updateStatusToCompleted({required String orderId}) async {
    try {
      var res = await apiClient.put('/api/orders/$orderId', data: {'status' : 'Completed'});
      return res.statusCode!;
    } on Dio catch (e) {
      print(e);
      throw Exception(msg_server_error);
    }
  }
}
