import 'package:appetit/domain/models/products.dart';
import 'package:appetit/screens/ProductDetailScreen.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductComponent extends StatelessWidget {
  final Product product;
  ProductComponent({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAvailable = product.quantity! > 0;
    return Container(
            width: context.width(),
            // padding: const EdgeInsets.all(8),
            child: IntrinsicHeight(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    isAvailable
                        ? FadeInImage.assetNetwork(
                                image: product.thumbnailUrl.toString(),
                                placeholder: 'image/appetit/placeholder.png',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover)
                            .cornerRadiusWithClipRRect(8)
                        : Stack(
                            children: [
                              FadeInImage.assetNetwork(
                                      image: product.thumbnailUrl.toString(),
                                      placeholder:
                                          'image/appetit/placeholder.png',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover)
                                  .cornerRadiusWithClipRRect(8),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ],
                          ),
                    8.width,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isAvailable
                                  ? context.iconColor
                                  : black.withOpacity(0.4)),
                        ),
                        product.productCategories != null
                            ? Text(
                                product.productCategories!.length >= 2
                                    ? product.productCategories!.first.category!
                                            .name
                                            .toString() +
                                        ' | +' +
                                        (product.productCategories!.length - 1)
                                            .toString()
                                    : product
                                        .productCategories!.first.category!.name
                                        .toString(),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              )
                            : SizedBox.shrink(),
                        Text(
                          '₫' +
                              FormatUtils.formatPrice(product.price!.toDouble())
                                  .toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '₫' +
                                      FormatUtils.formatPrice(product
                                              .promotionalPrice!
                                              .toDouble())
                                          .toString(),
                                  style: TextStyle(
                                      color: isAvailable
                                          ? context.iconColor
                                          : black.withOpacity(0.4),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Gap.k8.width,
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: isAvailable
                                              ? Colors.redAccent
                                              : Colors.redAccent
                                                  .withOpacity(0.4)),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    'Giảm ' +
                                        ((product.promotionalPrice! /
                                                    product.price!) *
                                                100)
                                            .round()
                                            .toString() +
                                        '%',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isAvailable
                                            ? Colors.redAccent
                                            : Colors.redAccent.withOpacity(0.4),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            isAvailable
                                ? Text(
                                    'Còn ' +
                                        DateTime.parse(product.expiredAt!)
                                            .difference(DateTime.now())
                                            .inDays
                                            .toString() +
                                        ' ngày',
                                    style: TextStyle(
                                        color: DateTime.parse(
                                                        product.expiredAt!)
                                                    .difference(DateTime.now())
                                                    .inDays <=
                                                10
                                            ? Colors.redAccent
                                            : DateTime.parse(product.expiredAt!)
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays <=
                                                        30 &&
                                                    DateTime.parse(product
                                                                .expiredAt!)
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays >
                                                        10
                                                ? Colors.orangeAccent
                                                : Colors.green),
                                  )
                                : Text(
                                    'Hết hàng',
                                    style: TextStyle(
                                        color: black.withOpacity(0.4)),
                                  )
                          ],
                        ),
                      ],
                    ).expand(),
                  ]),
            ))
        .onTap(() => Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: product));
  }
}
