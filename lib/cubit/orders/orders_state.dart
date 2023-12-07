import 'package:appetit/domain/models/order/orders.dart';

class OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersFailedState extends OrdersState {
  final String msg;
  OrdersFailedState({required this.msg});
}

class OrdersSuccessState extends OrdersState {
  final Orders orders;
  OrdersSuccessState({required this.orders});
}

//Create Order
class CreateOrderState {}

class CreateOrderLoadingState extends CreateOrderState {}

class CreateOrderFailedState extends CreateOrderState {
  final String msg;
  CreateOrderFailedState({required this.msg});
}

class CreateOrderSuccessState extends CreateOrderState {
  final int status;
  CreateOrderSuccessState({required this.status});
}

//Payment
class PaymentState {}

class PaymentLoadingState extends PaymentState {}

class PaymentFailedState extends PaymentState {
  final String msg;
  PaymentFailedState({required this.msg});
}

class PaymentSuccessState extends PaymentState {
  final String url;
  PaymentSuccessState({required this.url});
}
