import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/utils/appRoutes.dart';
import 'package:eCommerce/widgets/app_drawer.dart';
import 'package:eCommerce/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<ProductsProvider>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar produtos'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, i) => Column(
            children: <Widget>[
              ProductItem(product: products[i]),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
