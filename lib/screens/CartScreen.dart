import 'dart:async';
import 'package:appetit/cubit/cart/cart_cubit.dart';
import 'package:appetit/cubit/cart/cart_state.dart';
import 'package:appetit/cubit/orders/orders_cubit.dart';
import 'package:appetit/domain/models/cart.dart';
import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/screens/PaymentScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/format_utils.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, int> quantities = {};
  bool isQuantityChanged = false;
  Timer? updateTimer;
  Map<CartItem, bool> choosenItems = {};
  List<OrderDetails> orderDetailsList = [];
  int totalPrice = 0;
  int totalDiscount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateQuantity(BuildContext context, String id) {
    var cartCubit = BlocProvider.of<UpdateCartCubit>(context);
    cartCubit.updateCart(itemId: id, quantity: quantities[id]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<CreateOrderCubit>(
          create: (context) => CreateOrderCubit(),
        ),
        BlocProvider<UpdateCartCubit>(create: (context) => UpdateCartCubit())
      ],
      child: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
        if (state is CartLoadingState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: appetitAppContainerColor,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Giỏ hàng',
                style: TextStyle(color: context.iconColor, fontSize: 20),
              ),
            ),
            body: Column(children: [
              Row(
                children: [SkeletonWidget(borderRadius: 2, height: 16, width: 16), Gap.k16.width, SkeletonWidget(borderRadius: 8, height: 16, width: 100)],
              ),
              Row(
                children: [
                  SkeletonWidget(borderRadius: 2, height: 16, width: 16),
                  Gap.k16.width,
                  SkeletonWidget(borderRadius: 8, height: 80, width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonWidget(borderRadius: 8, height: 16, width: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonWidget(borderRadius: 7, height: 14, width: 50),
                          SkeletonWidget(borderRadius: 7, height: 14, width: 50),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [SkeletonWidget(borderRadius: 7, height: 14, width: 50), SkeletonWidget(borderRadius: 0, height: 20, width: 70)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonWidget(borderRadius: 7, height: 14, width: 50),
                          SkeletonWidget(borderRadius: 7, height: 14, width: 50),
                        ],
                      ),
                    ],
                  ).expand()
                ],
              )
            ]).paddingAll(16),
          );
        }
        if (state is CartSuccessState) {
          var groupedCartItems = state.cart.groupCartItemsByStore();
          var cart = state.cart.cartItems;
          if (quantities.isEmpty) {
            cart!.forEach((element) => quantities[element.id!] = element.quantity!);
          }
          if (choosenItems.isEmpty) {
            cart!.forEach((element) => choosenItems[element] = false);
          }
          choosenItems.forEach((cartItem, isSelected) {
            if (isSelected && !orderDetailsList.any((orderDetail) => orderDetail.productId == cartItem.product?.id)) {
              OrderDetails orderDetails = OrderDetails(
                productId: cartItem.product?.id,
                quantity: cartItem.quantity,
                price: cartItem.product?.promotionalPrice,
              );
              orderDetailsList.add(orderDetails);
            }
          });
          //   for (var i = 0; i < choosenItems.length; i++) {
          //     if (choosenItems.values.elementAt(i) == true && !orderDetailsList.any((orderDetail) =>
          // orderDetail.productId == choosenItems.keys.elementAt(i).product?.id)) {
          //       OrderDetails orderDetails = OrderDetails(
          //         productId: choosenItems.keys.elementAt(i).product?.id,
          //         quantity: choosenItems.keys.elementAt(i).quantity,
          //         price: choosenItems.keys.elementAt(i).product!.promotionalPrice,
          //       );
          //       orderDetailsList.add(orderDetails);
          //     }
          //   }
          // choosenItems.entries.where((entry) => entry.value).forEach((entry) {
          //   CartItem cartItem = entry.key;

          //   OrderDetails orderDetails = OrderDetails(
          //     productId: cartItem.product?.id,
          //     quantity: cartItem.quantity,
          //     price: cartItem.product?.promotionalPrice,
          //   );

          //   orderDetailsList.add(orderDetails);
          // });
          // final createOrderCubit = BlocProvider.of<CreateOrderCubit>(context);
          return Scaffold(
              backgroundColor: appLayout_background,
              appBar: AppBar(
                backgroundColor: appetitAppContainerColor,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: 'Giỏ hàng',
                      style: TextStyle(color: context.iconColor, fontSize: 20),
                    ),
                    TextSpan(
                      text: '(' + cart!.length.toString() + ')',
                      style: TextStyle(fontSize: 12, color: context.iconColor),
                    ),
                  ]),
                ),
              ),
              body: Stack(
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) => Gap.k8.height,
                    itemCount: groupedCartItems.length,
                    itemBuilder: (context, index) {
                      // final storeWithItems = storeItemsList[index];
                      final storeName = groupedCartItems.keys.toList()[index];
                      final cartItems = groupedCartItems[storeName]!;
                      return Container(
                        decoration: BoxDecoration(color: white),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.store_outlined),
                                Gap.k4.width,
                                Text(
                                  // storeItemsList[index].toString(),
                                  storeName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ).paddingAll(14),
                            ListView.separated(
                                separatorBuilder: (context, index) => Gap.k16.height,
                                shrinkWrap: true,
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  if (DateTime.parse(cartItems[index].product!.expiredAt!).isBefore(DateTime.now()) || (cartItems[index].product!.quantity! - cartItems[index].product!.sold! == 0)) {
                                    return Dismissible(
                                      key: Key(cartItems[index].id!),
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ).paddingRight(16),
                                      ),
                                      onDismissed: (direction) {
                                        // setState(() {
                                        //   items.removeAt(index);
                                        // });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 48, right: 16),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          Stack(
                                            children: [
                                              FadeInImage.assetNetwork(
                                                      image: cartItems[index].product!.thumbnailUrl.toString(), placeholder: 'image/appetit/placeholder.png', height: 80, width: 80, fit: BoxFit.cover)
                                                  .cornerRadiusWithClipRRect(8),
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(color: white.withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                          8.width,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItems[index].product!.name!,
                                                style: TextStyle(color: black.withOpacity(0.4), fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              cartItems[index].product!.productCategories != null
                                                  ? Text(
                                                      cartItems[index].product!.productCategories!.first.category!.name.toString(),
                                                      style: TextStyle(color: black.withOpacity(0.4), fontSize: 14),
                                                    )
                                                  : SizedBox.shrink(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '₫' + FormatUtils.formatPrice(cartItems[index].product!.price!.toDouble()).toString(),
                                                    style: TextStyle(
                                                      color: black.withOpacity(0.4),
                                                      fontSize: 14.0,
                                                      decoration: TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '₫' + FormatUtils.formatPrice(cartItems[index].product!.promotionalPrice!.toDouble()).toString(),
                                                    style: TextStyle(color: black.withOpacity(0.4), fontSize: 14.0, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Sản phẩm không tồn tại',
                                                    style: TextStyle(color: black.withOpacity(0.4), fontSize: 12.0, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ).expand(),
                                        ]),
                                      ),
                                    );
                                  } else {
                                    return Dismissible(
                                      key: Key(cartItems[index].id!),
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ).paddingRight(16),
                                      ),
                                      onDismissed: (direction) {
                                        // setState(() {
                                        //   items.removeAt(index);
                                        // });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          Checkbox(
                                              activeColor: Colors.orange.shade700,
                                              value: choosenItems[cartItems[index]] ?? false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  choosenItems[cartItems[index]] = value!;
                                                  if (value) {
                                                    totalPrice = totalPrice + quantities[cartItems[index].id]! * cartItems[index].product!.promotionalPrice!;
                                                    totalDiscount = totalDiscount + quantities[cartItems[index].id]! * (cartItems[index].product!.price! - cartItems[index].product!.promotionalPrice!);
                                                  } else {
                                                    totalPrice = totalPrice - quantities[cartItems[index].id]! * cartItems[index].product!.promotionalPrice!;
                                                    totalDiscount = totalDiscount - quantities[cartItems[index].id]! * (cartItems[index].product!.price! - cartItems[index].product!.promotionalPrice!);
                                                  }
                                                });
                                              }),
                                          FadeInImage.assetNetwork(
                                                  image: cartItems[index].product!.thumbnailUrl.toString(), placeholder: 'image/appetit/placeholder.png', height: 80, width: 80, fit: BoxFit.cover)
                                              .cornerRadiusWithClipRRect(8),
                                          8.width,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    cartItems[index].product!.name!,
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Còn ' + DateTime.parse(cartItems[index].product!.expiredAt!).difference(DateTime.now()).inDays.toString() + ' ngày',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: DateTime.parse(cartItems[index].product!.expiredAt!).difference(DateTime.now()).inDays <= 10
                                                            ? Colors.redAccent
                                                            : DateTime.parse(cartItems[index].product!.expiredAt!).difference(DateTime.now()).inDays <= 30 &&
                                                                    DateTime.parse(cartItems[index].product!.expiredAt!).difference(DateTime.now()).inDays > 10
                                                                ? Colors.orangeAccent
                                                                : Colors.green),
                                                  ),
                                                ],
                                              ),
                                              cartItems[index].product!.productCategories != null
                                                  ? Text(
                                                      cartItems[index].product!.productCategories!.first.category!.name.toString(),
                                                      style: TextStyle(color: Colors.grey, fontSize: 14),
                                                    )
                                                  : SizedBox.shrink(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '₫' + FormatUtils.formatPrice(cartItems[index].product!.price!.toDouble()).toString(),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14.0,
                                                      decoration: TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        child: Center(child: SvgPicture.asset('image/appetit/minus-solid.svg', width: 10, color: gray)),
                                                        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                                                      ).onTap(() {
                                                        setState(() {
                                                          if (quantities[cartItems[index].id]! > 1) {
                                                            quantities[cartItems[index].id!] = quantities[cartItems[index].id!]! - 1;
                                                            if (choosenItems[cartItems[index]]!) {
                                                              totalPrice = totalPrice - cartItems[index].product!.promotionalPrice!;
                                                              totalDiscount = totalDiscount - (cartItems[index].product!.price! - cartItems[index].product!.promotionalPrice!);
                                                            }
                                                          } else {
                                                            quantities[cartItems[index].id!] = 1;
                                                          }
                                                        });
                                                        updateQuantity(context, cartItems[index].id!);
                                                      }),
                                                      Container(
                                                        child: Center(child: Text(quantities[cartItems[index].id].toString())),
                                                        width: 30,
                                                        height: 20,
                                                        decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.grey))),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        child: Center(child: SvgPicture.asset('image/appetit/plus-solid.svg', width: 10, color: gray)),
                                                        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                                                      ).onTap(() {
                                                        setState(() {
                                                          if (quantities[cartItems[index].id!]! < cartItems[index].product!.quantity!) {
                                                            quantities[cartItems[index].id!] = quantities[cartItems[index].id!]! + 1;
                                                            if (choosenItems[cartItems[index]]!) {
                                                              totalPrice = totalPrice + cartItems[index].product!.promotionalPrice!;
                                                              totalDiscount = totalDiscount + (cartItems[index].product!.price! - cartItems[index].product!.promotionalPrice!);
                                                            }
                                                          } else {
                                                            quantities[cartItems[index].id!] = cartItems[index].product!.quantity!;
                                                          }
                                                        });
                                                        updateQuantity(context, cartItems[index].id!);
                                                      })
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '₫' + FormatUtils.formatPrice(cartItems[index].product!.promotionalPrice!.toDouble()).toString(),
                                                    style: TextStyle(color: Colors.orange.shade700, fontSize: 14.0, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Còn ' + (cartItems[index].product!.quantity!).toString() + ' sản phẩm',
                                                    style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ).expand(),
                                        ]),
                                      ),
                                    );
                                  }
                                }).paddingBottom(16),
                          ],
                        ),
                      );
                    },
                  ).paddingBottom(64),
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
                                Row(
                                  children: [
                                    Text(
                                      'Tổng',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Gap.k4.width,
                                    Text(
                                      '₫' + FormatUtils.formatPrice(totalPrice.toDouble()).toString(),
                                      style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Đã giảm', style: TextStyle(fontSize: 12)),
                                    Gap.k4.width,
                                    Text(
                                      '₫' + FormatUtils.formatPrice(totalDiscount.toDouble()).toString(),
                                      style: TextStyle(color: Colors.orange.shade700, fontSize: 10),
                                    )
                                  ],
                                )
                              ],
                            ),
                            choosenItems.values.where((element) => element == true).length > 0
                                ? BlocProvider<CreateOrderCubit>(
                                    create: (context) => CreateOrderCubit(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(4)),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Mua hàng',
                                            style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          choosenItems.values.where((element) => element == true).length > 0
                                              ? Row(
                                                  children: [
                                                    Gap.k4.width,
                                                    Text(
                                                      '(' + choosenItems.values.where((element) => element == true).length.toString() + ')',
                                                      style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    ).onTap(() {
                                      Navigator.pushNamed(context, PaymentScreen.routeName, arguments: {
                                        'cartItems': choosenItems.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList(),
                                        'order': CreateOrder(amount: totalPrice, isPayment: true, orderDetails: orderDetailsList)
                                      });
                                    }),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(color: grey, borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Mua hàng',
                                          style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ));
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appetitAppContainerColor,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Giỏ hàng',
              style: TextStyle(color: context.iconColor, fontSize: 20),
            ),
          ),
          body: Center(
            child: Text('Chưa có sản phẩm nào được thêm vào giỏ hàng'),
          ),
        );
      }),
    );
  }
}
