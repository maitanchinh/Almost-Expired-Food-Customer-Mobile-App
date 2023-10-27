import 'package:appetit/components/ProductComponent.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/product/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ProductsOfCategoryComponent extends StatefulWidget {
  final String categoryId;
  ProductsOfCategoryComponent({required this.categoryId});

  @override
  State<ProductsOfCategoryComponent> createState() =>
      _ProductsOfCategoryComponentState();
}

class _ProductsOfCategoryComponentState
    extends State<ProductsOfCategoryComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsCubit>(
      create: (context) => ProductsCubit(widget.categoryId),
      child:
          BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
        if (state is ProductsLoadingState) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProductsSuccessState) {
          if (state.products.product != null) {
            var products = state.products.product;

            return ListView.builder(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2, childAspectRatio: (1.3 / 1), mainAxisSpacing: 16, crossAxisSpacing: 16),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: products!.length,
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ProductComponent(product: products[index]);
              },
            );
          }
        }
        return SizedBox.shrink();
      }),
    );
  }
}
