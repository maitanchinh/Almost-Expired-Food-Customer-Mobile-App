import 'package:appetit/cubit/product/products_state.dart';
import 'package:appetit/domain/repositories/products_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo _productsRepo = getIt<ProductsRepo>();

  ProductsCubit(
      {String? categoryId,
      String? campaignId,
      String? name,
      bool? isPriceHighToLow,
      bool? isPriceLowToHight})
      : super(ProductsState()) {
    getProducts(
        categoryId: categoryId,
        campaignId: campaignId,
        name: name,
        isPriceHighToLow: isPriceHighToLow,
        isPriceLowToHight: isPriceLowToHight);
  }

  Future<void> getProducts(
      {String? categoryId,
      String? campaignId,
      String? name,
      bool? isPriceHighToLow,
      bool? isPriceLowToHight}) async {
    try {
      emit(ProductsLoadingState());
      final products = await _productsRepo.getProducts(
          categoryId, campaignId, name, isPriceHighToLow, isPriceLowToHight);
      emit(ProductsSuccessState(products: products));
    } on Exception catch (e) {
      emit(ProductsFailedState(msg: e.toString()));
    }
  }

  void refresh(){
    emit(ProductsLoadingState());
    getProducts();
  }

  // Future<void> getProductsByCampaignId(String campaignId) async {
  //   try {
  //     emit(ProductsLoadingState());
  //     final products = await _productsRepo.getProductsByCampaignId(campaignId);
  //     emit(ProductsSuccessState(products: products));
  //   } on Exception catch (e) {
  //     emit(ProductsFailedState(msg: e.toString()));
  //   }
  // }
}
