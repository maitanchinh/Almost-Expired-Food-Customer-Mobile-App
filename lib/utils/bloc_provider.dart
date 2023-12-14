import 'package:appetit/cubit/login/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notification/notification_cubit.dart';

List<BlocProvider> multiBlocProvider(){
  return [
    BlocProvider(create: (context) => LoginByGoogleCubit()),
    BlocProvider<NotificationCubit>(create: (context) {
          final notificationCubit = NotificationCubit();
          notificationCubit.getNotifications();
          return notificationCubit;
        })
  ];
}