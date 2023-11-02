import 'package:appetit/domain/models/stores.dart';

class StoresState {}

class StoresLoadingState extends StoresState {}

class StoresFailedState extends StoresState {
  final String msg;
  StoresFailedState({required this.msg});
}

class StoresSuccessState extends StoresState {
  final Stores stores;
  StoresSuccessState({required this.stores});
}
