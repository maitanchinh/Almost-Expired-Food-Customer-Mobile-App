import 'package:appetit/domain/models/transactions.dart';

class TransactionsState {}

class TransactionsLoadingState extends TransactionsState {}

class TransactionsFailedState extends TransactionsState {
  final String msg;
  TransactionsFailedState({required this.msg});
}

class TransactionsSuccessState extends TransactionsState {
  final Transactions transactions;
  TransactionsSuccessState({required this.transactions});
}
