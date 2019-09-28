import 'package:flutter/material.dart';

class CartItem {
  final String Id;
  final String title;
  final int quanity;
  final double price;

  CartItem(
      {@required this.Id,
      @required this.title,
      @required this.quanity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.quanity * cartItem.price;
    });

    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
          productId,
          (existingCardItem) => CartItem(
              Id: existingCardItem.Id,
              title: existingCardItem.title,
              price: existingCardItem.price,
              quanity: existingCardItem.quanity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              Id: DateTime.now().toString(),
              title: title,
              price: price,
              quanity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quanity > 1) {
      // reduce quantity...

      _items.update(
          productId,
          (existingCardItem) => CartItem(
              Id: existingCardItem.Id,
              title: existingCardItem.title,
              price: existingCardItem.price,
              quanity: existingCardItem.quanity - 1));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
