import 'dart:convert';

class Order {
  String? item;
  String? itemName;
  int? price;
  String? currency;
  int? quantity;

  Order(this.item, this.itemName, this.price, this.currency, this.quantity);

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      map['Item'],
      map['ItemName'],
      map['Price'],
      map['Currency'],
      map['Quantity'],
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      json['Item'],
      json['ItemName'],
      json['Price'],
      json['Currency'],
      json['Quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Item': item,
    'ItemName': itemName,
    'Price': price,
    'Currency': currency,
    'Quantity': quantity,
  };

  static List<Order> fromJsonList(String jsonList) {
    List<dynamic> list = jsonDecode(jsonList);
    return list.map<Order>((item) => Order.fromJson(item)).toList();
  }

  @override
  String toString() {
    return 'Order{item: $item, itemName: $itemName, price: $price, currency: $currency, quantity: $quantity}';
  }
}