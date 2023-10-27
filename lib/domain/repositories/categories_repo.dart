import 'package:appetit/domain/models/categories.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class CategoriesRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Categories> getCategories(String categoryGroupId) async {
    try {
      var res = await apiClient.get('/api/categories?categoryGroupId=$categoryGroupId');
      return Categories.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}