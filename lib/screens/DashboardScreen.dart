import 'package:appetit/cubit/campaigns/campaign_cubit.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/store/store_cubit.dart';
import 'package:appetit/cubit/stores/stores_cubit.dart';
import 'package:appetit/fragments/HomeFragment.dart';
import 'package:appetit/fragments/MapFragment.dart';
import 'package:appetit/fragments/NotificationFragment.dart';
import 'package:appetit/fragments/ProfileFragment.dart';
import 'package:appetit/fragments/SearchFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../cubit/categories/categories_cubit.dart';
import '../cubit/profile/account_cubit.dart';
import '../utils/Constants.dart';
import '../utils/app_shared.dart';

class DashboardScreen extends StatefulWidget {
  final int? tabIndex;
  static const String routeName = '/dashboard';
  DashboardScreen({Key? key, this.tabIndex}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedItem =  0;

  @override
  void initState(){
    super.initState();
    if (widget.tabIndex != null) {
      selectedItem = widget.tabIndex!;
    }
  }

  void onTapSelection(int index) {
    setState(() => selectedItem = index);
  }

  List<Widget> widgetOption = <Widget>[
    HomeFragment(),
    MapFragment(),
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
        BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit()),
        
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
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: StreamBuilder<int>(
                    stream: watchCountNotify(),
                    builder: (context, snapshot) {
                      int value = snapshot.data ?? 0;

                      if (value > 0) {
                        // return Badge.count(count: state.notifications.notifications!.where((noti) => noti.isRead == false).length, child: Icon(Icons.notifications_outlined));
                        return Badge.count(count: getIntAsync(AppConstant.NOTI_COUNT), child: Icon(Icons.notifications_outlined));
                      }
                      return Icon(Icons.notifications_outlined);
                    }),
                label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
