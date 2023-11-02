import 'package:appetit/domain/models/products.dart';

class ProductsState {}

class ProductsLoadingState extends ProductsState {}

class ProductsFailedState extends ProductsState {
  final String msg;
  ProductsFailedState({required this.msg});
}

class ProductsSuccessState extends ProductsState {
  final Products products;
  ProductsSuccessState({required this.products});
}
