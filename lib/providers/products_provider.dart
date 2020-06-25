import 'dart:math';

import 'package:eCommerce/data/dummy_data.dart';
import 'package:eCommerce/providers/product.dart';

import 'package:flutter/material.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = DUMMY_PRODUCTS;

  List<Product> get products => [..._products];
  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  int get productCount => _products.length;

  void addProducts(Product product) {
    _products.add(
      Product(
        id: Random().nextDouble().toString(),
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      ),
    );
    notifyListeners();
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }
    final index = _products.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    final index = _products.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      _products.removeWhere((element) => element.id == productId);
      notifyListeners();
    }
  }
}
// bool _showFavoritesOnly = false;
// void showFavoritesOnly() {
//   _showFavoritesOnly = true;
//   notifyListeners();
// }

// void showAll() {
//   _showFavoritesOnly = false;
//   notifyListeners();
// }
