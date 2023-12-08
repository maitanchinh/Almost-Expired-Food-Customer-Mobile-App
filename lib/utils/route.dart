import 'package:appetit/cubit/cart/cart_cubit.dart';
import 'package:appetit/cubit/orders/orders_cubit.dart';
import 'package:appetit/domain/models/campaigns.dart';
import 'package:appetit/domain/models/cart.dart';
import 'package:appetit/domain/models/industries.dart';
import 'package:appetit/domain/models/order/create.dart';
import 'package:appetit/domain/models/order/orders.dart';
import 'package:appetit/domain/models/products.dart';
import 'package:appetit/domain/models/stores.dart';
import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/screens/OrderDetailsScreen.dart';
import 'package:appetit/screens/OrdersCanceledScreen.dart';
import 'package:appetit/screens/OrdersCompletedScreen.dart';
import 'package:appetit/screens/LoginScreen.dart';
import 'package:appetit/screens/CartScreen.dart';
import 'package:appetit/screens/IndustryScreen.dart';
import 'package:appetit/screens/OrdersWaitConfirmScreen.dart';
import 'package:appetit/screens/OrdersWaitPaymentScreen.dart';
import 'package:appetit/screens/OrdersWaitPickUpScreen.dart';
import 'package:appetit/screens/PaymentScreen.dart';
import 'package:appetit/screens/ProductDetailScreen.dart';
import 'package:appetit/screens/CampaignsScreen.dart';
import 'package:appetit/screens/StoreScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PageRoute? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case DashboardScreen.routeName:
      return MaterialPageRoute(builder: (_) => DashboardScreen());
    case IndustryScreen.routeName:
      return MaterialPageRoute(builder: (_) => IndustryScreen(categoryGroup: settings.arguments as Industry));
    case ProductDetailScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider<AddToCartCubit>(
                create: (context) => AddToCartCubit(),
                child: ProductDetailScreen(
                  product: settings.arguments as Product,
                ),
              ));
    case StoreScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => StoreScreen(
                store: settings.arguments as Store,
              ));
    case CampaignsScreen.routeName:
      Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
      final products = arguments['products'] as List<Product>;
      final campaign = arguments['campaign'] as Campaign;
      return MaterialPageRoute(
          builder: (_) => CampaignsScreen(
                products: products,
                campaign: campaign,
              ));
    case CartScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
                BlocProvider<CartCubit>(
                  create: (context) => CartCubit(),
                ),
                BlocProvider<CreateOrderCubit>(
                  create: (context) => CreateOrderCubit(),
                ),
                BlocProvider<UpdateCartCubit>(create: (context) => UpdateCartCubit()),
                BlocProvider<RemoveCartItemCubit>(create: (context) => RemoveCartItemCubit())
              ], child: CartScreen()));
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case PaymentScreen.routeName:
      Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
      final cartItems = arguments['cartItems'] as List<CartItem>?;
      final order = arguments['order'] as CreateOrder?;

      if (cartItems != null && order != null) {
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CreateOrderCubit>(create: (context) => CreateOrderCubit(), child: PaymentScreen(cartItems: cartItems, order: order)),
        );
      }
      return MaterialPageRoute(builder: (_) => CartScreen());
    case OrdersCompletedScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<OrdersCubit>(create: (context) => OrdersCubit(), child: OrdersCompletedScreen()));
    case OrdersWaitPaymentScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
              providers: [BlocProvider<OrdersCubit>(create: (context) => OrdersCubit()), BlocProvider<PaymentCubit>(create: (context) => PaymentCubit())], child: OrdersWaitPaymentScreen()));
    case OrdersWaitConfirmScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<OrdersCubit>(create: (context) => OrdersCubit(), child: OrdersWaitConfirmScreen()));
    case OrdersWaitPickupScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
              providers: [BlocProvider<OrdersCubit>(create: (context) => OrdersCubit()), BlocProvider<CompleteOrderCubit>(create: (context) => CompleteOrderCubit())],
              child: OrdersWaitPickupScreen()));
    case OrdersCanceledScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<OrdersCubit>(create: (context) => OrdersCubit(), child: OrdersCanceledScreen()));
    case OrderDetailsScreen.routeName:
      Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
      final orderDetails = arguments['orderDetails'] as List<OrderDetails>;
      final amount = arguments['amount'] as int;
      return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
                orderDetails: orderDetails,
                amout: amount,
              ));
    default:
  }
  return null;
}
