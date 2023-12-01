import 'package:appetit/domain/models/cart.dart';
import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/screens/CartScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/orders/orders_cubit.dart';
import '../cubit/orders/orders_state.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';
  final List<CartItem> cartItems;
  final CreateOrder order;
  const PaymentScreen({Key? key, required this.cartItems, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderCubit = BlocProvider.of<CreateOrderCubit>(context);
    return Scaffold(
      backgroundColor: appLayout_background,
      appBar: MyAppBar(
        title: 'Thanh toán',
      ),
      body: Stack(
        children: [
          ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: white),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          size: 20,
                        ),
                        Gap.k8.width,
                        Text(
                          cartItems[index].store!.name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Gap.k16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: 'image/appetit/placeholder.png',
                          image: cartItems[index].product!.thumbnailUrl!,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(8),
                        Gap.k8.width,
                        SizedBox(
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cartItems[index].product!.name.toString()),
                              Builder(builder: (context) {
                                for (var category in cartItems[index].product!.productCategories!) {
                                  return Text(
                                    category.category!.name.toString(),
                                    style: TextStyle(fontSize: 12, color: grey),
                                  );
                                }
                                return SizedBox.shrink();
                              }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₫' + FormatUtils.formatPrice(cartItems[index].product!.promotionalPrice!.toDouble()),
                                    style: TextStyle(color: grey),
                                  ),
                                  Text(
                                    'Số lượng: ' + cartItems[index].quantity.toString(),
                                    style: TextStyle(fontSize: 12, color: grey),
                                  )
                                ],
                              )
                            ],
                          ),
                        ).expand()
                      ],
                    ),
                    Gap.k16.height,
                    Text(
                      'Chi nhánh nhận hàng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Gap.k8.height,
                    Container(
                      width: context.width(),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItems[index].branch!.address.toString(),
                                  style: TextStyle(fontSize: 12),
                                ),
                                Gap.k8.height,
                                Text('Số điện thoại: ' + cartItems[index].branch!.phone.toString(), style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${cartItems[index].branch!.latitude},${cartItems[index].branch!.longitude}'));
                              },
                              icon: Icon(
                                Icons.map_outlined,
                                color: iconColorSecondary,
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(border: Border.all(width: 0.3, color: iconColorSecondary), borderRadius: BorderRadius.circular(8)),
                    )
                  ]),
                );
              },
              separatorBuilder: (context, index) => Gap.k8.height,
              itemCount: cartItems.length).paddingBottom(64),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng thanh toán',
                          style: TextStyle(fontSize: 12),
                        ),
                        Gap.k4.width,
                        Text(
                          '₫' + FormatUtils.formatPrice(order.amount!.toDouble()).toString(),
                          style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        'Đặt hàng',
                        style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ).onTap(() async {
                      await orderCubit.createOrder(order);
                      // return BlocBuilder<CreateOrderCubit, CreateOrderState>(builder: (context, state) {
                      //   if (state is CreateOrderSuccessState) {
                      //     if (state.status == 201) {
                      //       showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return Dialog(
                      //                 child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               children: [
                      //                 Text('Đặt hàng thành công'),
                      //                 Gap.k16.height,
                      //                 TextButton(
                      //                     onPressed: () {
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: Text(
                      //                       'Đóng',
                      //                       style: TextStyle(fontWeight: FontWeight.bold),
                      //                     ))
                      //               ],
                      //             ));
                      //           });
                      //     }
                      //   }
                      //   return Dialog(
                      //       child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text('Đặt hàng thành công'),
                      //       Gap.k16.height,
                      //       TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           child: Text(
                      //             'Đóng',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ))
                      //     ],
                      //   ));
                      // });

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return OrderSubmitPopup(state: orderCubit.state,);
                          });
                    })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderSubmitPopup extends StatelessWidget {
  final CreateOrderState state;
  const OrderSubmitPopup({
    Key? key, required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(32.0),
        child: Builder(builder: (context) {
          if (state is CreateOrderLoadingState) {
            return Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Gap.k16.height,
                Text('Đang đặt hàng, vui lòng chờ.')
              ],
            );
          }
          if (state is CreateOrderSuccessState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Đặt hàng thành công'),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, CartScreen.routeName);
                      },
                      child: Text(
                        'Đóng',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              );

          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Đã xãy ra sự cố, hãy thử lại'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Đóng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          );
        }),
      ),
    );
  }
}
