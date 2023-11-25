import 'package:appetit/components/ADiscussionComponent.dart';
import 'package:appetit/cubit/cart/cart_cubit.dart';
import 'package:appetit/cubit/cart/cart_state.dart';
import 'package:appetit/cubit/store/store_cubit.dart';
import 'package:appetit/cubit/store/store_state.dart';
import 'package:appetit/domain/models/products.dart';
import 'package:appetit/screens/ADiscussionScreen.dart';
import 'package:appetit/screens/StoreScreen.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:appetit/main.dart';

import '../utils/format_utils.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var image = Image.asset('image/appetit/p3.jpg', fit: BoxFit.cover, color: Colors.black.withOpacity(0.5), colorBlendMode: BlendMode.darken);
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final addToCartCubit = BlocProvider.of<AddToCartCubit>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        actions: [],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: FadeInImage.assetNetwork(
                      image: widget.product.thumbnailUrl.toString(), placeholder: 'image/appetit/placeholder.png', width: MediaQuery.of(context).size.width, height: 250, fit: BoxFit.cover),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name.toString(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Còn ' + (widget.product.quantity! - widget.product.sold!).toString() + ' sản phẩm',
                        style: TextStyle(fontWeight: FontWeight.bold, color: white, fontSize: 10),
                      ),
                    )
                  ],
                ),
                Gap.k8.height,
                Row(
                  children: widget.product.productCategories!.map((e) {
                    return Row(
                      children: [
                        Text(
                          e.category!.name.toString() + '| ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Gap.k16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₫' + FormatUtils.formatPrice(widget.product.promotionalPrice!.toDouble()).toString(),
                          style: TextStyle(color: Colors.orange.shade600, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Gap.k4.width,
                        Text(
                          '₫' + FormatUtils.formatPrice(widget.product.price!.toDouble()).toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14.0,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey.shade300), borderRadius: BorderRadius.circular(16), shape: BoxShape.rectangle),
                          child: Center(
                              child: Container(
                            height: 1,
                            width: 15,
                            color: black,
                          )),
                        ).onTap(() {
                          setState(() {
                            if (quantity > 0) {
                              quantity--;
                            } else
                              quantity = 0;
                          });
                        }),
                        Gap.k16.width,
                        Text(
                          quantity.toString(),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Gap.k16.width,
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey.shade300), borderRadius: BorderRadius.circular(16), shape: BoxShape.rectangle),
                          child: Center(
                              child: Stack(
                            children: [
                              Positioned(
                                right: 17,
                                top: 10,
                                child: Container(
                                  height: 15,
                                  width: 1,
                                  color: black,
                                ),
                              ),
                              Positioned(
                                top: 17,
                                right: 10,
                                child: Container(
                                  height: 1,
                                  width: 15,
                                  color: black,
                                ),
                              ),
                            ],
                          )),
                        ).onTap(() {
                          setState(() {
                            if (quantity < widget.product.quantity!) {
                              quantity++;
                            } else {
                              quantity = widget.product.quantity!;
                            }
                          });
                        })
                      ],
                    )
                  ],
                ),
                Gap.k16.height,
                Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k8.height,
                Text(
                  widget.product.description.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                Gap.kSection.height,
                Text(
                  'Cửa hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k16.height,
                BlocProvider<StoreCubit>(
                  create: (context) => StoreCubit(productId: widget.product.id!),
                  child: BlocBuilder<StoreCubit, StoreState>(builder: (context, state) {
                    if (state is StoreLoadingState) {
                      return SizedBox.shrink();
                    }
                    if (state is StoreSuccessState) {
                      var store = state.store;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FadeInImage.assetNetwork(image: store.thumbnailUrl!, placeholder: 'image/appetit/store-placeholder-avatar.png', height: 40, width: 40, fit: BoxFit.cover),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(store.name!, style: TextStyle(fontWeight: FontWeight.w700)),
                                      Gap.k8.width,
                                    ],
                                  ),
                                  store.rated != null
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.star_outlined,
                                              color: Colors.orange.shade600,
                                              size: 16,
                                            ),
                                            Text(
                                              store.rated.toString(),
                                              style: TextStyle(color: Colors.orange.shade600),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.orange.shade600), borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              'Xem cửa hàng',
                              style: TextStyle(color: Colors.orange.shade600),
                            ),
                          ).onTap(() => Navigator.pushNamed(context, StoreScreen.routeName, arguments: store))
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ),
                Gap.kSection.height,

                //Discussion title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Đánh giá cửa hàng', style: TextStyle(fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ADiscussionScreen())),
                      child: Text('Xem tất cả', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Container(
                  child: Column(
                    children: [
                      //List of elements
                      ADiscussionComponent(),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                            filled: true,
                            labelText: 'Discuss here',
                            labelStyle: TextStyle(color: Colors.grey),
                            suffixIcon: Icon(Icons.send_outlined, color: Colors.orange.shade600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Gap.kSection.height,
                Gap.kSection.height,
                Gap.kSection.height,
              ],
            ),
          ),
          quantity > 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 50,
                          color: Colors.green,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Thêm giỏ hàng - ',
                                  style: TextStyle(color: white),
                                ),
                                SvgPicture.asset(
                                  'image/appetit/cart-shopping.svg',
                                  width: 20,
                                  color: white,
                                ),
                                Gap.k4.width,
                                Text(
                                  quantity.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: white),
                                )
                              ],
                            ),
                          ),
                        ).onTap(() async {
                          await addToCartCubit.addToCart(productId: widget.product.id.toString(), quantity: quantity);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ProcessingPopup(
                                  state: addToCartCubit.state,
                                );
                              });
                        }),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.orange.shade600,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('Tổng - ₫' + FormatUtils.formatPrice((quantity * widget.product.price!.toInt()).toDouble()).toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final AddToCartState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(32.0),
        child: Builder(builder: (context) {
          if (state is AddToCartLoadingState) {
            return Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Gap.k16.height,
                Text('Đang xử lý, vui lòng chờ.')
              ],
            );
          }
          if (state is AddToCartSuccessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Thêm vào giỏ hàng thành công'),
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
