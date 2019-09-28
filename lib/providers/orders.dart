import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/constants.dart';
import 'package:flutter_ecommerce/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;
  Orders(this.authToken,this.userId,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = "${YOUR_FIREBASE_DATABASE_PATH}/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();

    var response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cartProduct) => {
                    "id": cartProduct.Id,
                    "title": cartProduct.title,
                    "quanity": cartProduct.quanity,
                    "price": cartProduct.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = "${YOUR_FIREBASE_DATABASE_PATH}/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    print(json.decode(response.body));

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }

    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData["amount"],
        dateTime: DateTime.parse(orderData["dateTime"]),
        products: (orderData["products"] as List<dynamic>)
            .map((item) => CartItem(
                Id: item["id"],
                title: item["title"],
                quanity: item["quanity"],
                price: item["price"]))
            .toList(),
      ));
    });

    _orders = loadedOrders;
    notifyListeners();
  }
}
