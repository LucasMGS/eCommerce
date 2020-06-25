import 'package:eCommerce/providers/cart.dart';
import 'package:eCommerce/utils/appRoutes.dart';
import 'package:eCommerce/widgets/app_drawer.dart';
import 'package:eCommerce/widgets/badge.dart';
import 'package:eCommerce/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  FavoritesOnly,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool _showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha loja'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (filterValue) {
              setState(() {
                if (filterValue == FilterOptions.FavoritesOnly) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Somente favoritos'),
                value: FilterOptions.FavoritesOnly,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              value: cart.productCount.toString(),
              child: child,
            ),
          ),
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
