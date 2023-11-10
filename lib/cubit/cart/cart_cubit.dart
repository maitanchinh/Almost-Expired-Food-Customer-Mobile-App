import 'package:appetit/cubit/cart/cart_state.dart';
import 'package:appetit/domain/repositories/cart_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _cartRepo = getIt<CartRepo>();

  CartCubit() :super(CartState()){getCart();}

  Future<void> getCart()async{
    try {
      emit(CartLoadingState());
      final cart = await _cartRepo.getCart();
      emit(CartSuccessState(cart: cart));
    } on Exception catch (e) {
      emit(CartFailedState(msg: e.toString()));
    }
  }

}

//Update Cart
class UpdateCartCubit extends Cubit<UpdateCartState> {
  final CartRepo _cartRepo = getIt<CartRepo>();

  UpdateCartCubit() :super(UpdateCartState());

  Future<void> updateCart({String? itemId, int? quantity}) async {
    try {
      emit(UpdateCartLoadingState());
      final item = await _cartRepo.updateCart(itemId, quantity);
      emit(UpdateCartSuccessState(item: item));
    } on Exception catch (e) {
      emit(UpdateCartFailedState(msg: e.toString()));
    }
  }
  
}