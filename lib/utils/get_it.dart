import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/profile/account_cubit.dart';
import 'package:appetit/domain/repositories/account_repo.dart';
import 'package:appetit/domain/repositories/campaigns_repo.dart';
import 'package:appetit/domain/repositories/categories_repo.dart';
import 'package:appetit/domain/repositories/industries_repo.dart';
import 'package:appetit/domain/repositories/products_repo.dart';
import 'package:appetit/domain/repositories/store_repo.dart';
import 'package:appetit/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../domain/repositories/user_repo.dart';
final getIt = GetIt.instance;

Future<void> initialGetIt() async {
  getIt.registerLazySingleton<Dio>(() => apiClient);

  getIt.registerLazySingleton(() => UserRepo());
  getIt.registerLazySingleton(() => AccountRepo());
  getIt.registerLazySingleton(() => IndustriesRepo());
  getIt.registerLazySingleton(() => CategoriesRepo());
  getIt.registerLazySingleton(() => ProductsRepo());
  getIt.registerLazySingleton(() => StoreRepo());
  getIt.registerLazySingleton(() => CampaignsRepo());

  getIt.registerLazySingleton(() => IndustriesCubit());
  getIt.registerLazySingleton(() => AccountCubit());
}