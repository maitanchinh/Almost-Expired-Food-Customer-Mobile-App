import 'package:appetit/components/AccountComponent.dart';
import 'package:appetit/cubit/profile/account_cubit.dart';
import 'package:appetit/cubit/profile/account_state.dart';
import 'package:appetit/screens/OrdersCanceledScreen.dart';
import 'package:appetit/screens/OrdersCompletedScreen.dart';
import 'package:appetit/screens/OrdersWaitPaymentScreen.dart';
import 'package:appetit/screens/OrdersWaitPickUpScreen.dart';
import 'package:appetit/screens/TransactionsScreen.dart';
import 'package:appetit/screens/UpdateProfileScreen.dart';
import 'package:appetit/services/auth_service.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
      if (state is AccountLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is AccountSuccessState) {
        var account = state.account;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: SizedBox.shrink(),
            elevation: 0,
            backgroundColor: transparentColor,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, UpdateProfileScreen.routeName, arguments: account);
                  },
                  icon: Icon(Icons.edit_outlined))
            ],
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //1st content (Fixed height: 350)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                            child: Image.asset('image/appetit/backgroundprofile.jpg', width: MediaQuery.of(context).size.width, height: 220, fit: BoxFit.cover),
                          ),
                        ),
                        // Positioned(
                        //   top: 16 + MediaQuery.of(context).viewPadding.top,
                        //   right: 16,
                        //   child: ClipRRect(
                        //     // clipBehavior: Clip.antiAlias,
                        //     borderRadius: BorderRadius.circular(25),
                        //     child: Container(
                        //       color: Colors.black.withOpacity(0.5),
                        //       height: 50,
                        //       width: 50,
                        //       child: InkWell(
                        //           onTap: () {},
                        //           child: Icon(Icons.share_outlined,
                        //               color: Colors.white)),
                        //     ),
                        //   ),
                        // ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: context.width() * 2 / 3,
                            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: FadeInImage.assetNetwork(placeholder: 'image/appetit/avatar_placeholder.png', image: account.avatarUrl!, width: 80, height: 80, fit: BoxFit.cover),
                                ),
                                Gap.k8.height,
                                Text(account.name!, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                                Gap.k4.height,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    account.phone != null ? Text(account.phone!, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)) : SizedBox.shrink(),
                                    Text(account.email!, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
                                    // account.address != null ? Text(account.address!, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)) : SizedBox.shrink()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.kSection.height,
                  // AccountComponent(icon: 'image/appetit/confirm.png', content: 'Chờ xác nhận').onTap((){
                  //   Navigator.pushNamed(context, OrdersWaitConfirmScreen.routeName);
                  // }),
                  AccountComponent(icon: 'image/appetit/time-to-pay.png', content: 'Chờ thanh toán').onTap(() {
                    Navigator.pushNamed(context, OrdersWaitPaymentScreen.routeName);
                  }),
                  Gap.k8.height,
                  AccountComponent(icon: 'image/appetit/pickup.png', content: 'Chờ nhận hàng').onTap(() {
                    Navigator.pushNamed(context, OrdersWaitPickupScreen.routeName);
                  }),
                  Gap.k8.height,
                  AccountComponent(icon: 'image/appetit/order-completed.png', content: 'Đơn hàng đã nhận').onTap(() {
                    Navigator.pushNamed(context, OrdersCompletedScreen.routeName);
                  }),
                  Gap.k8.height,
                  AccountComponent(icon: 'image/appetit/cancel-order.png', content: 'Đơn đã hủy').onTap(() {
                    Navigator.pushNamed(context, OrdersCanceledScreen.routeName);
                  }),
                  Gap.k8.height,
                  Divider(),
                  Gap.k8.height,
                  AccountComponent(icon: 'image/appetit/transaction.png', content: 'Giao dịch', containerColor: Colors.green.shade100, iconColor: Colors.green.shade600,).onTap(() {
                    Navigator.pushNamed(context, TransactionsScreen.routeName);
                  }),
                  Gap.kSection.height,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: redColor.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent.shade700, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ).onTap((){
                    AuthService().signOut(context);
                  })
                  //2nd content (Social information)
                  // Gap.k16.height,
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 16),
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(15)),
                  //     color: appStore.isDarkModeOn
                  //         ? context.cardColor
                  //         : appetitAppContainerColor,
                  //   ),
                  //   height: 100,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text('24',
                  //               style: TextStyle(
                  //                   fontSize: 25,
                  //                   fontWeight: FontWeight.w800,
                  //                   color: context.iconColor)),
                  //           Text('Recipes',
                  //               style: TextStyle(
                  //                   fontSize: 13,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: context.iconColor)),
                  //         ],
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text('432',
                  //               style: TextStyle(
                  //                   fontSize: 25,
                  //                   fontWeight: FontWeight.w800,
                  //                   color: context.iconColor)),
                  //           Text('Following',
                  //               style: TextStyle(
                  //                   fontSize: 13,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: context.iconColor)),
                  //         ],
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text('643',
                  //               style: TextStyle(
                  //                   fontSize: 25,
                  //                   fontWeight: FontWeight.w800,
                  //                   color: context.iconColor)),
                  //           Text('Follow',
                  //               style: TextStyle(
                  //                   fontSize: 13,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: context.iconColor)),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ).onTap(() {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => AFollowersScreen()));
                  // },
                  //     highlightColor: Colors.transparent,
                  //     splashColor: Colors.transparent),
                  // SizedBox(height: 32),
                  // APopularRecipesComponent(),
                ],
              ),
            ),
          ),
        );
      }
      return SizedBox.shrink();
    });
  }
}
