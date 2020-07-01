import 'dart:convert';
import 'package:eCommerce/exceptions/http_exception.dart';
import 'package:eCommerce/providers/product.dart';
import 'package:eCommerce/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  String _token;
  String _userId;
  List<Product> get products => [..._products];

  ProductsProvider([this._token, this._userId, this._products = const []]);
  final _baseUrl = '${Constants.BASE_API_URL}/products';
  List<Product> _products = [];

  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  int get productCount => _products.length;

  Future<void> addProduct(Product product) async {
    final response = await http.post("$_baseUrl.json?auth=$_token",
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'description': product.description,
          },
        ));
    _products.add(Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }
    final index = _products.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${product.id}.json?auth=$_token",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _products[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String productId) async {
    final index = _products.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      final product = _products[index];
      _products.remove(product);
      notifyListeners();

      final response =
          await http.delete("$_baseUrl/$productId.json?auth=$_token");
      if (response.statusCode >= 400) {
        _products.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto!');
      }
    }
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);
    final favoriteResponse = await http.get(
        '${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token');
    final favMap = json.decode(favoriteResponse.body);
    _products.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        _products.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            isFavorite: isFavorite,
          ),
        );
      });
      notifyListeners();
    }
    return Future.value();
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
