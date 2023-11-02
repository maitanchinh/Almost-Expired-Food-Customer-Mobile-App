import 'package:appetit/components/ASearchLiveComponent.dart';
import 'package:appetit/components/CampaignsComponent.dart';
import 'package:appetit/components/MapComponent.dart';
import 'package:appetit/components/ProductsListComponent.dart';
import 'package:appetit/cubit/campaigns/campaign_cubit.dart';
import 'package:appetit/cubit/campaigns/campaigns_state.dart';
import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/utils/ADataProvider.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:appetit/utils/AColors.dart';
import 'package:appetit/main.dart';

class ASearchFragment extends StatefulWidget {
  ASearchFragment({Key? key}) : super(key: key);

  @override
  State<ASearchFragment> createState() => _ASearchFragmentState();
}

class _ASearchFragmentState extends State<ASearchFragment>
    with SingleTickerProviderStateMixin {
  var selectedItem = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CampaignsCubit>(
              create: (context) => CampaignsCubit()),
          BlocProvider<ProductsCubit>(
              create: (context) => ProductsCubit(name: _searchQuery)),
          BlocProvider<CategoriesCubit>(
            create: (context) => CategoriesCubit(name: _searchQuery),
          )
        ],
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              leading: SizedBox(),
              leadingWidth: 0,
              title: TextField(
                onChanged: (value) async {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.grey),
                  labelText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: 'Enter any name to search',
                  prefixIcon:
                      Icon(Icons.search_outlined, size: 24, color: Colors.grey),
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.zero,
                  fillColor: appStore.isDarkModeOn
                      ? context.cardColor
                      : appetitAppContainerColor,
                ),
              ).cornerRadiusWithClipRRect(16),
              elevation: 0,
              backgroundColor: context.scaffoldBackgroundColor,
              bottom: TabBar(
                indicatorColor: Colors.orange.shade600,
                isScrollable: true,
                physics: AlwaysScrollableScrollPhysics(),
                tabs: searchitems.map(
                  (e) {
                    // Check the file extension of the image
                    bool isSvg = e.image!.toLowerCase().endsWith('.svg');

                    return Row(
                      children: [
                        isSvg
                            ? SvgPicture.asset(
                                e.image.toString(),
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                e.image.toString(),
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                        Gap.k4.width,
                        Text(
                          e.text.toString(),
                          style:
                              TextStyle(color: context.iconColor, fontSize: 14),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 6);
                  },
                ).toList(),
              ),
            ),
            body: TabView(
              searchQuery: _searchQuery,
            ),
          ),
        ));
  }
}

class TabView extends StatelessWidget {
  final String searchQuery;
  const TabView({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaignsCubit = BlocProvider.of<CampaignsCubit>(context);
    campaignsCubit.getCampaignsList(name: searchQuery);

    return TabBarView(
      children: [
        BlocBuilder<CampaignsCubit, CampaignsState>(builder: (context, state) {
          if (state is CampaignsLoadingState) {
            return Center(
              child: CircularProgressIndicator()
            );
          }
          if (state is CampaignsSuccessState) {
            if (state.campaigns.campaign!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CampaignsComponent(campaigns: state.campaigns),
              );
            } else {
              return Center(
                child: Text('Không tìm thấy kết quả phù hợp'),
              );
            }
          }
          return SizedBox.shrink();
        }),
        ASearchLiveComponent(),
        ProductsListComponent(
          name: searchQuery,
        ),
        MapComponent()
      ],
    );
  }
}
