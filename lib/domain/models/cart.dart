import 'package:appetit/domain/models/products.dart';
import 'package:appetit/domain/models/stores.dart';

class Cart {
  String? id;
  List<CartItem>? cartItems;

  Cart({this.id, this.cartItems});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cartItems'] != null) {
      cartItems = <CartItem>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(new CartItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.cartItems != null) {
      data['cartItems'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, List<CartItem>> groupCartItemsByStore() {
    final groupedCartItems = <String, List<CartItem>>{};

    for (final cartItem in cartItems!) {
      final storeName = cartItem.store?.name ?? 'Unknown Store';
      if (groupedCartItems.containsKey(storeName)) {
        groupedCartItems[storeName]!.add(cartItem);
      } else {
        groupedCartItems[storeName] = [cartItem];
      }
    }
    return groupedCartItems;
  }
}

class CartItem {
  String? id;
  Store? store;
  Branches? branch;
  int? quantity;
  Product? product;

  CartItem({this.id, this.store, this.branch, this.quantity, this.product});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    branch =
        json['branch'] != null ? new Branches.fromJson(json['branch']) : null;
    quantity = json['quantity'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.toJson();
    }
    data['quantity'] = this.quantity;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}


class StoreOwner {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? avatarUrl;
  String? status;

  StoreOwner(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.avatarUrl,
      this.status});

  StoreOwner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    avatarUrl = json['avatarUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['avatarUrl'] = this.avatarUrl;
    data['status'] = this.status;
    return data;
  }
}

class Branches {
  String? id;
  String? address;
  double? latitude;
  double? longitude;
  String? phone;

  Branches({this.id, this.address, this.latitude, this.longitude, this.phone});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phone'] = this.phone;
    return data;
  }
}
