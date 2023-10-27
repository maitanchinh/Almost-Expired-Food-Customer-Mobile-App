import 'package:appetit/cubit/profile/account_state.dart';
import 'package:appetit/domain/models/account.dart';
import 'package:appetit/domain/repositories/account_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepo _accountRepo = getIt<AccountRepo>();
  AccountCubit() : super(AccountState()){
    getAccountProfile();
  }

  Future<void> getAccountProfile() async {
    try {
      emit(AccountLoadingState());
      Account account = await _accountRepo.getAccountInformation();
      emit(AccountSuccessState(account: account));
    } catch (e) {
      emit(AccountFailedState(message: e.toString()));
    }
  }
}