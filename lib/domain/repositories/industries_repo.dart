import 'package:appetit/domain/models/industries.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class IndustriesRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Industries> getCategoryGroups() async {
    try {
      var res = await apiClient.get('/api/category-groups');
      return Industries.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}