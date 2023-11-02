import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/categories/categories_state.dart';
import 'package:appetit/cubit/profile/account_cubit.dart';
import 'package:appetit/cubit/profile/account_state.dart';
import 'package:appetit/screens/CartScreen.dart';
import 'package:appetit/screens/IndustryScreen.dart';
import 'package:appetit/utils/AColors.dart';
import 'package:appetit/main.dart';
import 'package:appetit/screens/ACategoryListScreen.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/ADataProvider.dart';

class AHomeFragment extends StatefulWidget {
  const AHomeFragment({Key? key}) : super(key: key);

  @override
  State<AHomeFragment> createState() => _AHomeFragmentState();
}

class _AHomeFragmentState extends State<AHomeFragment> {
  var bookmarkSelection = true;

  @override
  Widget build(BuildContext context) {
    final _industriesCubit = GetIt.I.get<IndustriesCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BlocBuilder<AccountCubit, AccountState>(
                builder: (context, state) {
              if (state is AccountLoadingState) {
                return SizedBox.shrink();
              }
              if (state is AccountSuccessState) {
                return FadeInImage.assetNetwork(
                    image: state.account.avatarUrl.toString(),
                    placeholder: 'image/appetit/avatar_placeholder.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover);
              }
              return SizedBox.shrink();
            }),
          ),
        ),
        title: Align(
            alignment: Alignment.center,
            child: Text('Appetit', style: TextStyle(fontSize: 20))),
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart_outlined, size: 27, color: context.iconColor), onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _industriesCubit.refresh(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('What do you want to buy today?',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
              ),
              BlocBuilder<IndustriesCubit, IndustriesState>(
                  builder: (context, state) {
                if (state is IndustriesLoadingState) {
                  return SizedBox.shrink();
                }
                if (state is IndustriesSuccessState) {
                  var industry = state.industries.data;
                  return Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Categories',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ACategoryListScreen())),
                              child: Text('View all',
                                  style: TextStyle(
                                      color: appStore.isDarkModeOn
                                          ? Colors.grey
                                          : Colors.black.withOpacity(0.4))),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Row(
                              children: industry!.map((e) {
                                return Container(
                                  margin: EdgeInsets.only(right: 16.0),
                                  width: 120,
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Image.asset(e.categoryicon.toString(), width: 30, height: 30, fit: BoxFit.cover),
                                      SizedBox(width: 4),
                                      Text(e.name.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: context.iconColor))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: appStore.isDarkModeOn
                                          ? context.cardColor
                                          : appetitAppContainerColor,
                                      borderRadius: BorderRadius.circular(15)),
                                ).onTap(() => Navigator.of(context).pushNamed(
                                    IndustryScreen.routeName,
                                    arguments: e));
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              }),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Live Cooking',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 32,
                          decoration: BoxDecoration(
                            color: appStore.isDarkModeOn
                                ? context.cardColor
                                : appetitAppContainerColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.adjust_outlined,
                                  color: Colors.red, size: 20),
                              Text(' 500 live',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: context.iconColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('View all',
                          style: TextStyle(
                              color: appStore.isDarkModeOn
                                  ? Colors.grey
                                  : Colors.black.withOpacity(0.4))),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                padding: EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: cookingmodal.take(4).map((e) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(35),
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Stack(
                            children: [
                              Image.asset(
                                e.image.toString(),
                                height: 180,
                                width: 270,
                                color: Colors.black.withOpacity(0.4),
                                colorBlendMode: BlendMode.darken,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 16,
                                left: 16,
                                child: SizedBox(
                                  height: 40,
                                  width: 156,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              Colors.white24.withOpacity(0.25),
                                          shape: StadiumBorder()),
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            child: ClipOval(
                                              child: Image.asset(
                                                e.chefpic.toString(),
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            radius: 15,
                                          ),
                                          SizedBox(width: 8),
                                          Text(e.chefname.toString(),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      )),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 110,
                                      height: 30,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            child: Image.asset(
                                                'image/appetit/user7.jpg',
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          Positioned(
                                            left: 15,
                                            child: ClipRRect(
                                              child: Image.asset(
                                                  'image/appetit/topchef6.jpg',
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: appStore.isDarkModeOn
                                                    ? context.cardColor
                                                    : appetitAppContainerColor,
                                                borderRadius: radiusOnly(
                                                    bottomRight: 20,
                                                    topRight: 20),
                                              ),
                                              height: 30,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 8),
                                              child: Text('+ 99 k',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: context
                                                              .iconColor))
                                                  .center(),
                                            ),
                                          ),
                                          Positioned(
                                            left: 30,
                                            child: ClipRRect(
                                              child: Image.asset(
                                                  'image/appetit/a_face.jpeg',
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.crop_free_outlined,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 16,
                                top: 80,
                                right: 16,
                                child: Text(e.data.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Gap.k16.height,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Cửa hàng nổi bật',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  children: topchefmodal.getRange(2, 6).map((e) {
                    return Container(
                      height: 180,
                      width: 106,
                      padding: EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.asset(e.image.toString(),
                                      width: 90,
                                      height: 120,
                                      fit: BoxFit.cover))),
                          SizedBox(height: 8),
                          Text(e.name.toString()),
                          Text(e.recipe.toString()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Gap.k16.height,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Chiến dịch mới',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              // CampaignsComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
