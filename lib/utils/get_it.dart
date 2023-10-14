import 'package:appetit/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../domain/repositories/user_repo.dart';
final getIt = GetIt.instance;

Future<void> initialGetIt() async {
  getIt.registerLazySingleton<Dio>(() => apiClient);

  getIt.registerLazySingleton(() => UserRepo());
}