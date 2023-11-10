import 'package:appetit/components/ProductsListComponent.dart';
import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/categories/categories_state.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/domain/models/campaigns.dart';
import 'package:appetit/domain/models/categories.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domain/models/products.dart';

class CampaignsScreen extends StatelessWidget {
  static const routeName = '/products';
  final List<Product> products;
  final Campaign campaign;
  const CampaignsScreen(
      {Key? key, required this.products, required this.campaign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          campaign.name.toString(),
          style:
              TextStyle(color: context.iconColor, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: appetitAppContainerColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
        child: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
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
        );
      }
      return SizedBox.shrink();
    });
  }
}

class ScrollView extends StatefulWidget {
  final int tabLength;
  final Categories categories;
  const ScrollView(
      {Key? key, required this.categories, required this.tabLength})
      : super(key: key);

  @override
  State<ScrollView> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<ScrollView>
    with SingleTickerProviderStateMixin {
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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: SizedBox.shrink(),
          leadingWidth: 0,
          pinned: true,
          backgroundColor: white,
          title: SizedBox(
            height: 40,
            child: Center(
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.orange.shade600,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.orange.shade600,
                controller: tabController,
                tabs: widget.categories.categories!
                    .map((e) => Center(child: Text(e.name.toString())))
                    .toList(),
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
              controller: tabController,
              children: widget.categories.categories!.map((e) {
                return ProductsListComponent(categoryId: e.id.toString());
              }).toList()),
        ),
      ],
    );
  }
}
