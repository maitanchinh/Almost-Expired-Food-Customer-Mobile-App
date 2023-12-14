import 'package:appetit/components/ProductsListComponent.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  static const String routeName = '/category';
  final categoryId;
  const CategoryScreen({Key? key, this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(categoryId);
    return Scaffold(
      appBar: MyAppBar(title: 'Sản phẩm',),
      body: ProductsListComponent(categoryId: categoryId),
    );
  }
}