import 'package:appetit/domain/models/store.dart';

class StoreState {}

class StoreLoadingState extends StoreState {}

class StoreFailedState extends StoreState {
  final String msg;
  StoreFailedState({required this.msg});
}

class StoreSuccessState extends StoreState {
  final Store store;
  StoreSuccessState({required this.store});
}
