import 'package:appetit/domain/models/campaigns.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class CampaignsRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Campaigns> getCampaignsList(String? storeOwnerId, String? branchId, String? storeId, String? name) async {
    try {
      var res = await apiClient.get('/api/campaigns', queryParameters: {'storeOwnerId': storeOwnerId, 'branchId' : branchId, 'storeId': storeId,  'name' : name});
      return Campaigns.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  // Future<Campaigns> searchCampaign(String name) async {
  //   try {
  //     var res = await apiClient.get('/api/campaigns?name=$name');
  //     return Campaigns.fromJson(res.data);
  //   } on DioException {
  //     throw Exception(msg_server_error);
  //   }
  // }
}