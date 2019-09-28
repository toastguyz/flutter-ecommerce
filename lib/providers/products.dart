import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/constants.dart';
import 'package:flutter_ecommerce/models/http_exception.dart';
import 'package:flutter_ecommerce/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }

  /*Future<void> addProduct(Product product) {
    const url = "${YOUR_FIREBASE_DATABASE_PATH}/products.json";
    http
        .post(url,
            body: json.encode({
              "title": product.title,
              "price": product.price,
              "imageUrl": product.imageUrl,
              "description": product.description,
              "isFavorite": product.isFavorite,
            }))
        .then((response) {
      _items.add(Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description));
      notifyListeners();
    }).catchError((onError) {
      print("onError : ${onError}");
      throw onError;
    });
  }*/

  Future<void> addProduct(Product product) async {
    final url =
        "${YOUR_FIREBASE_DATABASE_PATH}/products.json?auth=$authToken";

    try {
      var response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "description": product.description,
            "creatorId": userId,
          }));

      _items.add(Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url;
    if (filterByUser) {
      url =
          '${YOUR_FIREBASE_DATABASE_PATH}/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    } else {
      url =
          '${YOUR_FIREBASE_DATABASE_PATH}/products.json?auth=$authToken';
    }

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final favUrl =
          "${YOUR_FIREBASE_DATABASE_PATH}/userFavourites/$userId.json?auth=$authToken";
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);

      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData["title"],
          description: prodData["description"],
          price: prodData["price"],
          imageUrl: prodData["imageUrl"],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          "${YOUR_FIREBASE_DATABASE_PATH}/products/$id.json?auth=$authToken";
      await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("Failure !!!");
    }
  }

  /*void deleteProduct(String productId) {
    final url =
        "${YOUR_FIREBASE_DATABASE_PATH}/products/$productId.json";

    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    http.delete(url).then((response) {
      if(response.statusCode>=400){
        throw HttpException("Failed to delete product!!");
      }
      existingProduct = null;
    }).catchError((error) {
      print("Error : ${error}");

      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
  }*/

  Future<void> deleteProduct(String productId) async {
    final url =
        "${YOUR_FIREBASE_DATABASE_PATH}/products/$productId.json?auth=$authToken";

    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      throw HttpException("Failed to delete product!!");
    }
    existingProduct = null;
  }
}
