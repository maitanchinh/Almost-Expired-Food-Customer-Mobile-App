
import 'package:appetit/cubit/home/home_state.dart';
import 'package:appetit/domain/repositories/categories_repo.dart';
import 'package:appetit/domain/repositories/industries_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

//INDUSTRies
class IndustriesCubit extends Cubit<IndustriesState> {
  final IndustriesRepo _industriesRepo = getIt<IndustriesRepo>();

  IndustriesCubit() :super(IndustriesState()){
    getIndustries();
  }

  Future<void> getIndustries() async {
    try {
      emit(IndustriesLoadingState());
      var industries = await _industriesRepo.getCategoryGroups();
      emit(IndustriesSuccessState(industries: industries));
    } on Exception catch (e) {
      emit(IndustriesFailedState(msg: e.toString()));
    }
  }

  void refresh(){
    emit(IndustriesLoadingState());
    getIndustries();
  }
}

//CATEGORY
class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepo _categoriesRepo = getIt<CategoriesRepo>();

  CategoriesCubit({required String categoryGroupId}) :super(CategoriesState()){
    getCategories(categoryGroupId);
  }

  Future<void> getCategories(String categoryGroupId) async {
    try {
      emit(CategoriesLoadingState());
      var categories = await _categoriesRepo.getCategories(categoryGroupId);
      emit(CategoriesSuccessState(categories: categories));
    } on Exception catch (e) {
      emit(CategoriesFailedState(msg: e.toString()));
    }
  }
}