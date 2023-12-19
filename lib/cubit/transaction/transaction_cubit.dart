import 'package:appetit/cubit/transaction/transaction_state.dart';
import 'package:appetit/domain/repositories/transaction_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final TransactionRepo _transactionRepo = getIt<TransactionRepo>();
class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit() :super(TransactionsState());

  Future<void> getTransactions({String? status}) async {
    try {
      emit(TransactionsLoadingState());
      var transactions = await _transactionRepo.getTransactions(status: status);
      emit(TransactionsSuccessState(transactions: transactions));
    } on Exception catch (e) {
      emit(TransactionsFailedState(msg: e.toString()));
    }
  }
}