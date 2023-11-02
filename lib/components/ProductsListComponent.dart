import 'package:appetit/components/ProductComponent.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/product/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ProductsListComponent extends StatefulWidget {
  final String? categoryId;
  final String? name;
  ProductsListComponent({this.categoryId, this.name});

  @override
  State<ProductsListComponent> createState() =>
      _ProductsListComponentState();
}

class _ProductsListComponentState
    extends State<ProductsListComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsCubit>(
      create: (context) => ProductsCubit(categoryId: widget.categoryId, name: widget.name),
      child: ProductsList(categoryId: widget.categoryId, name: widget.name),
    );
  }
}

class ProductsList extends StatelessWidget {
  final String? categoryId;
  final String? name;
  const ProductsList({Key? key, required this.categoryId, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
      if (state is ProductsLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is ProductsSuccessState) {
        var products = state.products.products;
        if (products!.isEmpty || !products.any((element) => DateTime.parse(element.expiredAt!).isAfter(DateTime.now()))) {
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
