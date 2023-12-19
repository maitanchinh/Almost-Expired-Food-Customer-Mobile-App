import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/profile/account_cubit.dart';
import 'package:appetit/cubit/store/store_cubit.dart';
import 'package:appetit/domain/repositories/account_repo.dart';
import 'package:appetit/domain/repositories/branch_repo.dart';
import 'package:appetit/domain/repositories/campaigns_repo.dart';
import 'package:appetit/domain/repositories/cart_repo.dart';
import 'package:appetit/domain/repositories/categories_repo.dart';
import 'package:appetit/domain/repositories/feedback_repo.dart';
import 'package:appetit/domain/repositories/industries_repo.dart';
import 'package:appetit/domain/repositories/notification_repo.dart';
import 'package:appetit/domain/repositories/orders_repo.dart';
import 'package:appetit/domain/repositories/products_repo.dart';
import 'package:appetit/domain/repositories/store_repo.dart';
import 'package:appetit/domain/repositories/transaction_repo.dart';
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
  getIt.registerLazySingleton(() => CartRepo());
  getIt.registerLazySingleton(() => OrdersRepo());
  getIt.registerLazySingleton(() => BranchRepo());
  getIt.registerLazySingleton(() => NotificationRepo());
  getIt.registerLazySingleton(() => FeedbackRepo());
  getIt.registerLazySingleton(() => TransactionRepo());

  getIt.registerLazySingleton(() => IndustriesCubit());
  getIt.registerLazySingleton(() => AccountCubit());
  getIt.registerLazySingleton(() => ProductsCubit());
  getIt.registerLazySingleton(() => StoreCubit());
}