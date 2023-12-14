import 'package:appetit/utils/get_it.dart';
import 'package:dio/dio.dart';

import '../models/notifications.dart';

class NotificationRepo {
  final Dio _apiClient = getIt.get<Dio>();
  Future<Notifications> getNotifications() async {
    try {
      var res = await _apiClient.get('/api/notifications/customers');
      return Notifications.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<int> markAsRead({required String notificationId}) async {
    try {
      var res = await _apiClient.put('/api/notifications/$notificationId', data: {'isRead' : true});
      return res.statusCode!;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}