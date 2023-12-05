import 'package:appetit/cubit/campaigns/campaign_cubit.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/store/store_cubit.dart';
import 'package:appetit/cubit/stores/stores_cubit.dart';
import 'package:appetit/fragments/HomeFragment.dart';
import 'package:appetit/fragments/NotificationFragment.dart';
import 'package:appetit/fragments/ProfileFragment.dart';
import 'package:appetit/fragments/SearchFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/categories/categories_cubit.dart';
import '../cubit/profile/account_cubit.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedItem = 0;

  void onTapSelection(int index) {
      setState(() => selectedItem = index);
  }

  List<Widget> widgetOption = <Widget>[
    HomeFragment(),
    SearchFragment(),
    NotificationFragment(),
    ProfileFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IndustriesCubit()),
        BlocProvider<AccountCubit>(
          create: (context) => AccountCubit(),
        ),
        BlocProvider<ProductsCubit>(create: (context) => ProductsCubit()),
        BlocProvider<StoreCubit>(create: (context) => StoreCubit()),
        BlocProvider<CampaignsCubit>(create: (context) => CampaignsCubit()),
        BlocProvider<StoresCubit>(create: (context) => StoresCubit()),
        BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit())
      ],
      child: Scaffold(
        body: widgetOption.elementAt(selectedItem),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 25,
          backgroundColor: Color(0xFF462F4C),
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedItem,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: onTapSelection,
          elevation: 0,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.orangeAccent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                label: 'Notification'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
