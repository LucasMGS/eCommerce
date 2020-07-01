import 'dart:convert';
import 'package:eCommerce/models/cartItem.dart';
import 'package:eCommerce/models/order.dart';
import 'package:eCommerce/providers/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  final _baseUrl = 'https://ecommerce-dd3fb.firebaseio.com/orders';
  List<Order> _orders = [];
  String _token;
  String _userId;
  OrderProvider([this._token, this._userId, this._orders = const []]);

  List<Order> get orders => [..._orders];

  int get orderCount => _orders.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post("$_baseUrl/$_userId.json?auth=$_token",
        body: json.encode({
          'total': cart.getTotalAmount,
          'date': date.toIso8601String(),
          'products': cart.products.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.getTotalAmount,
        date: date,
        products: cart.products.values.toList(),
      ),
    );
    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get("$_baseUrl/$_userId.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);

    loadedItems.clear();
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItems.add(
          Order(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                price: item['price'],
                productId: item['productId'],
                quantity: item['quantity'],
                title: item['title'],
              );
            }).toList(),
          ),
        );
      });
      notifyListeners();
    }
    _orders = loadedItems.reversed.toList();
    return Future.value();
  }
}
