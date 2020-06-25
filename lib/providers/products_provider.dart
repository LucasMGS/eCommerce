import 'package:eCommerce/data/dummy_data.dart';
import 'package:eCommerce/providers/product.dart';

import 'package:flutter/material.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = DUMMY_PRODUCTS;

  List<Product> get products => [..._products];
  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  void addProducts(Product product) {
    _products.add(product);
    notifyListeners();
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
