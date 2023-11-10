class CreateOrder {
  int? amount;
  bool? isPayment;
  List<OrderDetails>? orderDetails;

  CreateOrder({this.amount, this.isPayment, this.orderDetails});
}

class OrderDetails {
  String? productId;
  int? quantity;
  int? price;

  OrderDetails({this.productId, this.quantity, this.price});
}
