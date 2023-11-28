import 'package:appetit/components/ProductComponent.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/product/products_state.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ProductsListComponent extends StatefulWidget {
  final String? categoryId;
  final String? name;
  ProductsListComponent({this.categoryId, this.name});

  @override
  State<ProductsListComponent> createState() => _ProductsListComponentState();
}

class _ProductsListComponentState extends State<ProductsListComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsCubit>(create: (context) => ProductsCubit(), child: ProductsList(categoryId: widget.categoryId, name: widget.name));
  }
}

class ProductsList extends StatelessWidget {
  final String? categoryId;
  final String? name;
  const ProductsList({Key? key, required this.categoryId, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsCubit = BlocProvider.of<ProductsCubit>(context);
    productsCubit.getProducts(categoryId: categoryId, name: name);
    return BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
      if (state is ProductsLoadingState) {
        return ListView.builder(
            itemCount: 6,
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            itemBuilder: (context, index) {
              return Container(
                width: context.width(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SkeletonWidget(borderRadius: 8, height: 80, width: 80),
                    Gap.k8.width,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonWidget(borderRadius: 7, height: 14, width: 100),
                        SkeletonWidget(borderRadius: 7, height: 14, width: 70),
                        SkeletonWidget(borderRadius: 7, height: 14, width: 70),
                        Row(
                          children: [
                            SkeletonWidget(borderRadius: 7, height: 14, width: 60),
                            Gap.k8.width,
                            SkeletonWidget(borderRadius: 4, height: 20, width: 60)
                          ],
                        )
                      ],
                    ).expand(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SkeletonWidget(borderRadius: 8, height: 16, width: 80),
                        Gap.k8.height,
                        SkeletonWidget(borderRadius: 4, height: 32, width: 60)
                      ],
                    )
                  ],
                ),
              );
            });
      }
      if (state is ProductsSuccessState) {
        var products = state.products.products;
        if (products!.isEmpty ||
            !products.any((element) =>
                DateTime.parse(element.expiredAt!).isAfter(DateTime.now()))) {
          return Center(
            child: Text('Các sản phẩm đã được bán hết'),
          );
        } else {
          return ListView.builder(
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2, childAspectRatio: (1.3 / 1), mainAxisSpacing: 16, crossAxisSpacing: 16),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: products.length,
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ProductComponent(product: products[index]),
              );
            },
          );
        }
      }
      return SizedBox.shrink();
    });
  }
}