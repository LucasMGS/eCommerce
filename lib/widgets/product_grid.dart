import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final products = showFavoriteOnly
        ? productProvider.favoriteProducts
        : productProvider.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
    );
  }
}
