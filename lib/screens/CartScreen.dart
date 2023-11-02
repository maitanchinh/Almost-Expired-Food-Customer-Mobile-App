import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Giỏ hàng', style: TextStyle(color: context.iconColor),),
            Gap.k4.width,
            Text('(9)', style: TextStyle(fontSize: 12, color: context.iconColor),)
          ],
        ),
      ),
    );
  }
}