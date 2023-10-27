import 'package:appetit/cubit/product/products_state.dart';
import 'package:appetit/domain/repositories/products_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo _productsRepo = getIt<ProductsRepo>();

  ProductsCubit(String categoryId) : super(ProductsState()){
    getProductsByCategory(categoryId);
  }

  Future<void> getProductsByCategory(String categoryId) async {
    try {
      emit(ProductsLoadingState());
      final products = await _productsRepo.getProductsByCategory(categoryId);
      emit(ProductsSuccessState(products: products));
    } on Exception catch (e) {
      emit(ProductsFailedState(msg: e.toString()));
    }
  }
}