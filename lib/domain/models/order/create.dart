class CreateOrder {
  int? amount;
  String? paymentMethod;
  List<OrderDetails>? orderDetails;

  CreateOrder({this.amount, this.paymentMethod, this.orderDetails});

  CreateOrder.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    paymentMethod = json['isPayment'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['isPayment'] = this.paymentMethod;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  String? productId;
  int? quantity;
  int? price;

  OrderDetails({this.productId, this.quantity, this.price});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}
