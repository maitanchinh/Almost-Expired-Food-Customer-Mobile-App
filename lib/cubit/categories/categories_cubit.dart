
import 'package:appetit/cubit/categories/categories_state.dart';
import 'package:appetit/domain/repositories/categories_repo.dart';
import 'package:appetit/domain/repositories/industries_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

//INDUSTRIES
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

  CategoriesCubit({String? categoryGroupId, String? campaignId, String? name}) :super(CategoriesState()){
    getCategories(categoryGroupId: categoryGroupId, campaignId: campaignId, name: name);
  }

  Future<void> getCategories({String? categoryGroupId, String? campaignId, String? name}) async {
    try {
      emit(CategoriesLoadingState());
      var categories = await _categoriesRepo.getCategories(categoryGroupId, campaignId, name);
      emit(CategoriesSuccessState(categories: categories));
    } on Exception catch (e) {
      emit(CategoriesFailedState(msg: e.toString()));
    }
  }

  // Future<void> getCategoriesByCampaignId(String campaignId)async{
  //   try {
  //     emit(CategoriesLoadingState());
  //     var categories = await _categoriesRepo.getCategoriesByCampaignId(campaignId);
  //     emit(CategoriesSuccessState(categories: categories));
  //   } on Exception catch (e) {
  //     emit(CategoriesFailedState(msg: e.toString()));
  //   }
  // }

  // Future<void> searchCategory(String name) async {
  //   try {
  //     emit(CategoriesLoadingState());
  //     var categories = await _categoriesRepo.searchCategory(name);
  //     emit(CategoriesSuccessState(categories: categories));
  //   } on Exception catch (e) {
  //     emit(CategoriesFailedState(msg: e.toString()));
  //   }
  // }
}