
import 'package:appetit/cubit/login/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> multiBlocProvider(){
  return [
    BlocProvider(create: (context) => LoginByGoogleCubit()),
  ];
}