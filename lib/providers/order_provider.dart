import 'dart:math';
import 'package:eCommerce/models/order.dart';
import 'package:eCommerce/providers/cart.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  int get orderCount => _orders.length;

  void addOrder(Cart cart) {
    _orders.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        total: cart.getTotalAmount,
        date: DateTime.now(),
        products: cart.products.values.toList(),
      ),
    );
    notifyListeners();
  }
}
