import 'package:appetit/domain/models/categories.dart';
import 'package:appetit/domain/models/industries.dart';

//INDUSTRIES
class IndustriesState {}

class IndustriesLoadingState extends IndustriesState {}

class IndustriesFailedState extends IndustriesState {
  final String msg;
  IndustriesFailedState({required this.msg});
}

class IndustriesSuccessState extends IndustriesState {
  final Industries industries;
  IndustriesSuccessState({required this.industries});
}

//CATEGORIES
class CategoriesState {
  
}

class CategoriesLoadingState extends CategoriesState {
  
}

class CategoriesFailedState extends CategoriesState {
  final String msg;
  CategoriesFailedState({required this.msg});
}

class CategoriesSuccessState extends CategoriesState {
  final Categories categories;
  CategoriesSuccessState({required this.categories});
}