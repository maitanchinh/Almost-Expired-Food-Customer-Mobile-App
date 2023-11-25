import 'package:appetit/domain/models/cart.dart';

//Cart
class CartState {}

class CartLoadingState extends CartState {}

class CartFailedState extends CartState {
  final String msg;
  CartFailedState({required this.msg});
}

class CartSuccessState extends CartState {
  final Cart cart;
  CartSuccessState({required this.cart});
}

//Update cart
class UpdateCartState {}

class UpdateCartLoadingState extends UpdateCartState {}

class UpdateCartFailedState extends UpdateCartState {
  final String msg;
  UpdateCartFailedState({required this.msg});
}

class UpdateCartSuccessState extends UpdateCartState {
  final CartItem item;
  UpdateCartSuccessState({required this.item});
}

//Add to cart
class AddToCartState {}

class AddToCartLoadingState extends AddToCartState {}

class AddToCartSuccessState extends AddToCartState {
  final int statusCode;
  AddToCartSuccessState({required this.statusCode});
}

class AddToCartFailedState extends AddToCartState {
  final String msg;
  AddToCartFailedState({required this.msg});
}
