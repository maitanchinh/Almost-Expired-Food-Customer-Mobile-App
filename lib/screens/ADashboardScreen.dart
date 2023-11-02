import 'package:appetit/cubit/store/store_cubit.dart';
import 'package:appetit/fragments/AHomeFragment.dart';
import 'package:appetit/fragments/ANotificationFragment.dart';
import 'package:appetit/fragments/AProfileFragment.dart';
import 'package:appetit/screens/AAddRecipeScreen.dart';
import 'package:appetit/fragments/ASearchFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/categories/categories_cubit.dart';
import '../cubit/profile/account_cubit.dart';

class ADashboardScreen extends StatefulWidget {
  ADashboardScreen({Key? key}) : super(key: key);

  @override
  State<ADashboardScreen> createState() => _ADashboardScreenState();
}

class _ADashboardScreenState extends State<ADashboardScreen> {
  int selectedItem = 0;

  void onTapSelection(int index) {
    if (index == 2)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AAddRecipeScreen()));
    else
      setState(() => selectedItem = index);
  }

  List<Widget> widgetOption = <Widget>[
    AHomeFragment(),
    ASearchFragment(),
    SizedBox(),
    ANotificationFragment(),
    AProfileFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IndustriesCubit()),
        BlocProvider<AccountCubit>(
          create: (context) => AccountCubit(),
        ),
        // BlocProvider(create: (context) => StoreCubit(productId))
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
                icon: Icon(Icons.add_circle_outline_outlined), label: 'Reels'),
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
