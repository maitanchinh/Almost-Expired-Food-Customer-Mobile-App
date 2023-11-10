import 'package:appetit/domain/models/cart.dart';
import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';
  final List<CartItem> cartItems;
  final CreateOrder order;
  const PaymentScreen({Key? key, required this.cartItems, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appLayout_background,
      appBar: MyAppBar(
        title: 'Thanh toán',
      ),
      body: ListView.separated(
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
                  'Chọn chi nhánh',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k8.height,
                SizedBox(
                  height: 90,
                  width: context.width(),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Gap.k8.width,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: cartItems[index].store!.branches!.length,
                      itemBuilder: (context, branchIndex) {
                        var branch = cartItems[index].store!.branches![branchIndex];
                        var latitude = branch.latitude;
                        var longitude = branch.longitude;
                        return Container(
                            width: context.width() * 2/3,
                            padding: EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(branch.address.toString(), style: TextStyle(fontSize: 12),),
                                      Gap.k8.height,
                                      Text('Số điện thoại: ' + branch.phone.toString(), style: TextStyle(fontSize: 12))
                                    ],
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude'));
                                }, icon: Icon(Icons.map_outlined, color: iconColorSecondary,))
                              ],
                            ),
                            decoration: BoxDecoration(border: Border.all(width: 0.3, color: iconColorSecondary), borderRadius: BorderRadius.circular(8)),
                          );
                      }),
                )
              ]),
            );
          },
          separatorBuilder: (context, index) => Gap.k8.height,
          itemCount: cartItems.length),
    );
  }
}

// context.read<CreateOrderCubit>().createOrder(
//                                     CreateOrder(
//                                         amount: totalPrice,
//                                         isPayment: true,
//                                         orderDetails: orderDetailsList));
//                                 showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return Dialog(
//                                         child: Container(
//                                           height: 200,
//                                           width: 150,
//                                           padding: const EdgeInsets.all(32.0),
//                                           child: BlocBuilder<CreateOrderCubit,
//                                                   CreateOrderState>(
//                                               builder: (context, state) {
//                                             if (state
//                                                 is CreateOrderLoadingState) {
//                                               return Column(
//                                                 children: [
//                                                   Center(
//                                                     child:
//                                                         CircularProgressIndicator(),
//                                                   ),
//                                                   Gap.k16.height,
//                                                   Text(
//                                                       'Đang đặt hàng, vui lòng chờ.')
//                                                 ],
//                                               );
//                                             }
//                                             if (state
//                                                 is CreateOrderSuccessState) {
//                                               if (state.status == 201) {
//                                                 return Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Text('Đặt hàng thành công'),
//                                                     Gap.k16.height,
//                                                     TextButton(
//                                                         onPressed: () {
//                                                           Navigator.of(context)
//                                                               .pop();
//                                                         },
//                                                         child: Text(
//                                                           'Đóng',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ))
//                                                   ],
//                                                 );
//                                               }
//                                             }
//                                             return Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                     'Đã xãy ra sự cố, hãy thử lại'),
//                                                 Gap.k16.height,
//                                                 TextButton(
//                                                     onPressed: () {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                     },
//                                                     child: Text(
//                                                       'Đóng',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ))
//                                               ],
//                                             );
//                                           }),
//                                         ),
//                                       );
//                                     });
