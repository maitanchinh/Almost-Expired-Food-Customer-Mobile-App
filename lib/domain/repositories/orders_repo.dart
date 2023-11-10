import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class OrdersRepo {
  final Dio apiClient = getIt.get<Dio>();

  // Future<Orders> getAllOrder() async {
  //   try {
  //     var res = await apiClient.get
  //   } on DioException {
  //     throw Exception(msg_server_error);
  //   }
  // }

  Future<int?> createOrder(CreateOrder data) async {
    try {
      var res = await apiClient.post('/api/orders', data: {
        'amount': data.amount,
        'isPayment': data.isPayment,
        'orderDetails': data.orderDetails
      });
      return res.statusCode;
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}
