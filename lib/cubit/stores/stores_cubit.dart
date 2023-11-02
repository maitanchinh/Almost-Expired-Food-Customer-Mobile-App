import 'package:appetit/cubit/stores/stores_state.dart';
import 'package:appetit/domain/repositories/store_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoreRepo _storeRepo = getIt<StoreRepo>();

  StoresCubit({String? name, bool? bestRated}) : super(StoresState()){
    getStoresList(name: name, bestRated: bestRated);
  }

    Future<void> getStoresList({String? name, bool? bestRated}) async {
    try {
      emit(StoresLoadingState());
      final stores = await _storeRepo.getStoresList(name, bestRated);
      emit(StoresSuccessState(stores: stores));
    } on Exception catch (e) {
      emit(StoresFailedState(msg: e.toString()));
    }
  }
}