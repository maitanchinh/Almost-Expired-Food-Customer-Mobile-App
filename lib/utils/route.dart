import 'package:appetit/domain/models/industries.dart';
import 'package:appetit/domain/models/products.dart';
import 'package:appetit/screens/IndustryScreen.dart';
import 'package:appetit/screens/ProductDetailScreen.dart';
import 'package:flutter/material.dart';

PageRoute? generateRoute(RouteSettings settings){
  switch (settings.name) {
    case IndustryScreen.routeName:
      return MaterialPageRoute(builder: (_) => IndustryScreen(categoryGroup: settings.arguments as Industry));
    case ProductDetailScreen.routeName:
    return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: settings.arguments as Product,)); 
        
    default:
  }
  return null;
}