import 'dart:math';
import 'package:eCommerce/models/cartItem.dart';
import 'package:eCommerce/providers/product.dart';
import 'package:flutter/cupertino.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _products = {};

  Map<String, CartItem> get products => {..._products};

  int get productCount => _products.length;

  double get getTotalAmount {
    double total = 0.0;
    _products.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }

  void addItem(Product product) {
    if (_products.containsKey(product.id)) {
      _products.update(
        product.id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: product.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          title: existingCartItem.title,
        ),
      );
    } else {
      _products.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products.remove(productId);
    notifyListeners();
  }

  void clear() {
    _products = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_products.containsKey(productId)) {
      return;
    }

    if (_products[productId].quantity == 1) {
      _products.remove(productId);
    } else {
      _products.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          title: existingCartItem.title,
        ),
      );
    }
    notifyListeners();
  }
}
