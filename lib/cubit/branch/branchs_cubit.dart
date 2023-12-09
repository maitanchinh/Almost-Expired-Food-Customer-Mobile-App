import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/branch_repo.dart';
import 'branchs_state.dart';

class BranchsCubit extends Cubit<BranchsState> {
  final BranchRepo _branchRepo = getIt<BranchRepo>();
  BranchsCubit() :super(BranchsInitialState());

  Future<void> getBranchs({double? latitude, double? longitude}) async {
    try {
      emit(BranchsLoadingState());
      final branchs = await _branchRepo.getBranchs(latitude: latitude, longitude: longitude);
      emit(BranchsSuccessState(branchs: branchs));
    } on Exception catch (e) {
      emit(BranchsFailedState(msg: e.toString()));
    }
  }

  void refresh(){
    emit(BranchsLoadingState());
    getBranchs();
  }
}
