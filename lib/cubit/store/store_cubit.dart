import 'package:appetit/cubit/store/store_state.dart';
import 'package:appetit/domain/repositories/store_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepo _storeRepo = getIt<StoreRepo>();

  StoreCubit({String? productId}) : super(StoreState()){
    getStoreByProductId(productId: productId);
  }

  Future<void> getStoreByProductId({String? productId}) async{
    try {
      emit(StoreLoadingState());
      final store = await _storeRepo.getStoreByProductId(productId);
      emit(StoreSuccessState(store: store));
    } on Exception catch (e) {
      emit(StoreFailedState(msg: e.toString()));
    }
  }
}