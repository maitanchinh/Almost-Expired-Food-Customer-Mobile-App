import 'package:appetit/components/ProductsListComponent.dart';
import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/categories/categories_state.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/domain/models/campaigns.dart';
import 'package:appetit/domain/models/categories.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domain/models/products.dart';

class CampaignsScreen extends StatelessWidget {
  static const routeName = '/products';
  final List<Product> products;
  final Campaign campaign;
  const CampaignsScreen({Key? key, required this.products, required this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appLayout_background,
      appBar: MyAppBar(
        title: campaign.name,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<CategoriesCubit>(
            create: (context) => CategoriesCubit(categoryGroupId: null, campaignId: campaign.id, name: null),
          ),
          BlocProvider<ProductsCubit>(
            create: (context) => ProductsCubit(),
          )
        ],
        child: Body(
          campaign: campaign,
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  final Campaign campaign;
  const Body({
    Key? key,
    required this.campaign,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(builder: (context, state) {
      if (state is CategoriesLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is CategoriesSuccessState) {
        var categories = state.categories;
        return ScrollView(
          categories: categories,
          tabLength: categories.categories!.length,
          campaign: widget.campaign,
        );
      }
      return SizedBox.shrink();
    });
  }
}

class ScrollView extends StatefulWidget {
  final int tabLength;
  final Categories categories;
  final Campaign campaign;
  const ScrollView({Key? key, required this.categories, required this.tabLength, required this.campaign}) : super(key: key);

  @override
  State<ScrollView> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<ScrollView> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.tabLength, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          FadeInImage.assetNetwork(
            placeholder: 'image/appetit/placeholder.png',
            image: widget.campaign.thumbnailUrl!,
            height: 170,
            width: context.width(),
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 16,
            bottom: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bắt đầu: ' + FormatUtils.formatDate(widget.campaign.startTime!), style: TextStyle(color: white, fontWeight: FontWeight.bold),),
                    Text('Kết thúc: ' + FormatUtils.formatDate(widget.campaign.endTime!), style: TextStyle(color: white, fontWeight: FontWeight.bold),),
                    Text('Địa điểm: ' + widget.campaign.branch!.address!, style: TextStyle(color: white, fontWeight: FontWeight.bold),)
                  ],
                ),
            decoration: BoxDecoration(color: black.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
          ))
        ]), // Thêm widget của bạn ở đây

        SizedBox(
          height: 40,
          child: TabBar(
            isScrollable: true,
            labelColor: Colors.orange.shade600,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.orange.shade600,
            controller: tabController,
            tabs: widget.categories.categories!.map((e) => Center(child: Text(e.name.toString()))).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: widget.categories.categories!.map((e) {
              return ProductsListComponent(
                categoryId: e.id.toString(),
                campaignId: widget.campaign.id,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
