import 'package:appetit/domain/models/campaigns.dart';
import 'package:appetit/domain/models/industries.dart';
import 'package:appetit/domain/models/products.dart';
import 'package:appetit/domain/models/store.dart';
import 'package:appetit/screens/CartScreen.dart';
import 'package:appetit/screens/IndustryScreen.dart';
import 'package:appetit/screens/ProductDetailScreen.dart';
import 'package:appetit/screens/CampaignsScreen.dart';
import 'package:appetit/screens/StoreScreen.dart';
import 'package:flutter/material.dart';

PageRoute? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case IndustryScreen.routeName:
      return MaterialPageRoute(
          builder: (_) =>
              IndustryScreen(categoryGroup: settings.arguments as Industry));
    case ProductDetailScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(
                product: settings.arguments as Product,
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
          builder: (_) =>
              CampaignsScreen(products: products, campaign: campaign,));
    case CartScreen.routeName: 
    return MaterialPageRoute(builder: (_) => CartScreen());
    default:
  }
  return null;
}
