import 'package:appetit/cubit/campaigns/campaigns_state.dart';
import 'package:appetit/domain/repositories/campaigns_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

class CampaignsCubit extends Cubit<CampaignsState> {
  final CampaignsRepo _campaignsRepo = getIt<CampaignsRepo>();

  CampaignsCubit({String? storeOwnerId, String? storeId, String? branchId, String? name})
      : super(CampaignsState()) {
    getCampaignsList(
        storeOwnerId: storeOwnerId, branchId: branchId, storeId: storeId, name: name);
  }

  Future<void> getCampaignsList(
      {String? storeOwnerId, String? storeId, String? branchId, String? name}) async {
    try {
      emit(CampaignsLoadingState());
      final campaigns =
          await _campaignsRepo.getCampaignsList(storeOwnerId, branchId, storeId, name);
      emit(CampaignsSuccessState(campaigns: campaigns));
    } on Exception catch (e) {
      emit(CampaignsFailedState(msg: e.toString()));
    }
  }

  // Future<void> searchCampaign(String name) async {
  //   try {
  //     emit(CampaignsLoadingState());
  //     final campaigns = await _campaignsRepo.searchCampaign(name);
  //     emit(CampaignsSuccessState(campaigns: campaigns));
  //   } on Exception catch (e) {
  //     emit(CampaignsFailedState(msg: e.toString()));
  //   }
  // }
}
