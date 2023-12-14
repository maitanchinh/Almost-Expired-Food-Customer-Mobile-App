import 'package:appetit/screens/OrdersCompletedScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../cubit/orders/orders_cubit.dart';
import '../cubit/orders/orders_state.dart';
import '../utils/format_utils.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';
import 'OrderDetailsScreen.dart';

class OrdersWaitPickupScreen extends StatelessWidget {
  static const String routeName = '/wait-pickup';
  const OrdersWaitPickupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersCubit = BlocProvider.of<OrdersCubit>(context);
    final completeOrderCubit = BlocProvider.of<CompleteOrderCubit>(context);
    ordersCubit.getOrdersList(status: 'Pending Pickup');
    return Scaffold(
      appBar: MyAppBar(
        title: 'Chờ nhận hàng',
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoadingState) {
              return Center(child: CircularProgressIndicator(),);
            }
          if (state is OrdersSuccessState) {
            var orders = state.orders.orders;
            if (orders!.isNotEmpty) {
              return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (context, index) {
                    var orderItem = orders[index].orderDetails!.first.product!;
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: white),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: 'image/appetit/placeholder.png',
                                  image: orderItem.thumbnailUrl.toString(),
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                                Gap.k8.width,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(orderItem.name.toString()),
                                    Text(
                                      'Số lượng: ' + orders[index].orderDetails!.first.quantity.toString(),
                                      style: TextStyle(color: grey, fontSize: 12),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '₫' + FormatUtils.formatPrice(orderItem.price!.toDouble()).toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Gap.k8.width,
                                        Text(
                                          '₫' + FormatUtils.formatPrice(orderItem.promotionalPrice!.toDouble()).toString(),
                                          style: TextStyle(
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ).paddingSymmetric(horizontal: 16),
                          ),
                          orders[index].orderDetails!.length > 1
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text(
                                      'Xem thêm sản phẩm',
                                      style: TextStyle(color: grey, fontSize: 12),
                                    )
                                  ],
                                ).onTap(() {
                                  Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: {'orderDetails': orders[index].orderDetails, 'amount': orders[index].amount});
                                })
                              : SizedBox.shrink(),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                orders[index].orderDetails!.length.toString() + ' sản phẩm',
                                style: TextStyle(fontSize: 12, color: grey),
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(text: 'Tổng tiền: ', style: TextStyle(color: context.iconColor, fontSize: 14)),
                                TextSpan(text: '₫' + FormatUtils.formatPrice(orders[index].amount!.toDouble()).toString(), style: TextStyle(color: Colors.orange.shade700, fontSize: 14))
                              ])),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.orange.shade700), borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    Text(
                                      'Đã nhận hàng',
                                      style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                                    )
                                  ],
                                ),
                              ).onTap(() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Xác nhận'),
                                      content: Text('Xác nhận đã nhận hàng thành công.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false); // Đóng hộp thoại và trả về giá trị false
                                          },
                                          child: Text('Hủy'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true); // Đóng hộp thoại và trả về giá trị true
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Xác nhận'),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  if (value != null && value) {
                                    completeOrderCubit.completeOrder(orderId: orders[index].id!);
                                    Navigator.pushNamed(context, OrdersCompletedScreen.routeName);
                                  }
                                });
                              })
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap.k8.height,
                  itemCount: orders.length);
            } else {
              return Center(
                child: Text('Chưa có đơn hàng.'),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
