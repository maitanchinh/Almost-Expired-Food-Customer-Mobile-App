import 'package:appetit/components/CampaignsComponent.dart';
import 'package:appetit/cubit/campaigns/campaign_cubit.dart';
import 'package:appetit/cubit/campaigns/campaigns_state.dart';
import 'package:appetit/domain/models/stores.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/Colors.dart';

class StoreScreen extends StatefulWidget {
  static const String routeName = '/store';
  final Store store;
  const StoreScreen({Key? key, required this.store}) : super(key: key);
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    // Define the number of tabs (2 in this case)
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: appetitBrownColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: FadeInImage.assetNetwork(
                      image: widget.store.thumbnailUrl!,
                      placeholder: 'image/appetit/store-placeholder-avatar.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover),
                ),
                Gap.k8.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.store.name!,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: white),
                    ),
                    widget.store.rated != null
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star_outlined,
                                color: Colors.orange.shade600,
                                size: 16,
                              ),
                              Text(
                                widget.store.rated.toString(),
                                style: TextStyle(color: Colors.orange.shade600, fontSize: 14),
                              ),
                            ],
                          )
                        :  Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star_outlined,
                                color: Colors.orange.shade600,
                                size: 16,
                              ),
                              Text(
                                'Chưa có đánh giá',
                                style: TextStyle(color: Colors.orange.shade600, fontSize: 14),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
                labelColor: Colors.orange.shade600,
                unselectedLabelColor: black,
                indicatorColor: Colors.orange.shade600,
                controller: tabController,
                tabs: [
                  Tab(
                    text: 'Chiến dịch',
                  ),
                  Tab(
                    text: 'Chi nhánh',
                  ),
                ]),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tabController, // Associate the TabController
              children: [
                MultiBlocProvider(
                  providers: [
                    BlocProvider<CampaignsCubit>(
                        create: (context) => CampaignsCubit(storeId: widget.store.id)),
                    // BlocProvider<ProductsCubit>(create: (context) => ProductsCubit(campaignId: )),
                  ],
                  child: Campaigns(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.separated(itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: context.width() - 60, child: Text(widget.store.branches![index].address.toString())),
                            Text(widget.store.branches![index].phone.toString())
                          ],
                        ),
                        Icon(Icons.directions, color: iconColorSecondary,).onTap(() async {
                          await launchUrl(Uri.parse('http://maps.google.com/maps?q=${widget.store.branches![index].latitude},${widget.store.branches![index].longitude}&iwloc=A'));
                        })
                      ],
                    );
                  }, separatorBuilder: (context, index){
                    return Divider();
                  }, itemCount: widget.store.branches!.length),
                )
                // Content for the 'Chi nhánh' tab
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Campaigns extends StatelessWidget {
  const Campaigns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampaignsCubit, CampaignsState>(
                      builder: (context, state) {
                    if (state is CampaignsLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is CampaignsSuccessState) {
                      var campaigns = state.campaigns.campaigns!;
                      return CampaignsComponent(
                        campaigns: campaigns,
                      ).paddingTop(16);
                    }
                    return SizedBox.shrink();
                  });
  }
}