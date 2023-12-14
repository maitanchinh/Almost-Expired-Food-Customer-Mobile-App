import 'package:appetit/cubit/orders/orders_state.dart';
import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/domain/repositories/orders_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

  final OrdersRepo _ordersRepo = getIt<OrdersRepo>();
//Create order
class CreateOrderCubit extends Cubit<CreateOrderState> {

  CreateOrderCubit() :super(CreateOrderState());

  Future<void> createOrder(CreateOrder order) async{
    try {
      emit(CreateOrderLoadingState());
      final status = await _ordersRepo.createOrder(order);
      emit(CreateOrderSuccessState(status: status));
    } on Exception catch (e) {
      emit(CreateOrderFailedState(msg: e.toString()));
    }
  }
}

//Orders
class OrdersCubit extends Cubit<OrdersState> {

  OrdersCubit() :super(OrdersState());

  Future<void> getOrdersList({String? status, bool? isPayment}) async{
    try {
      emit(OrdersLoadingState());
      final orders = await _ordersRepo.getOrdersList(status: status, isPayment: isPayment);
      emit(OrdersSuccessState(orders: orders));
    } on Exception catch (e) {
      emit(OrdersFailedState(msg: e.toString()));
    }
  }
}

//Order details
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit({required String orderId}) :super(OrderDetailsState()){getOrderDetails(orderId: orderId);}
  Future<void> getOrderDetails({required String orderId}) async {
    try {
      emit(OrdersDetailsLoadingState());
      var order = await _ordersRepo.getOrderById(orderId: orderId);
      emit(OrderDetailsSuccessState(order: order));
    } on Exception catch (e) {
      emit(OrderDetailsFailedState(msg: e.toString()));
    }
  }
}

//Payment
class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit():super(PaymentState());
  Future<void> payment({required int amount, required String orderId}) async {
    try {
      // emit(PaymentLoadingState());
      var url = await _ordersRepo.payment(amount: amount, orderId: orderId);
      emit(PaymentSuccessState(url: url));
    } on Exception catch (e) {
      emit(PaymentFailedState(msg: e.toString()));
    }
  }

  
}
  //Complete order
  class CompleteOrderCubit extends Cubit<CompleteOrderState> {
    CompleteOrderCubit():super(CompleteOrderState());
    Future<void> completeOrder({required String orderId}) async {
      try {
        emit(CompleteOrderLoadingState());
        var statusCode = await _ordersRepo.updateStatusToCompleted(orderId: orderId);
        emit(CompleteOrderSuccessState(statusCode: statusCode));
      } on Exception catch (e) {
        emit(CompleteOrderFailedState(msg: e.toString()));
      }
    }
  }
