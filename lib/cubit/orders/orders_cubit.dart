import 'package:appetit/cubit/orders/orders_state.dart';
import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/domain/repositories/orders_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final OrdersRepo _ordersRepo = getIt<OrdersRepo>();

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
