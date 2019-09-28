import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce/constants.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavouriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final url = "${YOUR_FIREBASE_DATABASE_PATH}/userFavourites/$userId/$id.json?auth=$authToken";
    try {
      /*final response = await http.patch(url,
          body: json.encode({
            "isFavorite": isFavorite,
          }));*/

      final response = await http.put(url,
          body: json.encode({
            isFavorite,
          }));

      print("hello");
      if (response.statusCode >= 400) {
        print("hello1");
        _setFavValue(oldStatus);
      }
    } catch (error) {
      print("hello2");
      print("error : ${error.toString()}");
      _setFavValue(oldStatus);
    }
  }

  void _setFavValue(bool oldStatus) {
    isFavorite = oldStatus;
    notifyListeners();
  }
}
