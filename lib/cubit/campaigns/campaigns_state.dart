import 'package:appetit/domain/models/campaigns.dart';

class CampaignsState {
  
}

class CampaignsLoadingState extends CampaignsState {
  
}

class CampaignsFailedState extends CampaignsState {
  final String msg;
  CampaignsFailedState({required this.msg});
}

class CampaignsSuccessState extends CampaignsState {
  final Campaigns campaigns;
  CampaignsSuccessState({required this.campaigns});
}