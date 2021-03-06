import 'package:eCommerce/providers/auth_provider.dart';
import 'package:eCommerce/providers/cart.dart';
import 'package:eCommerce/providers/product.dart';
import 'package:eCommerce/utils/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final AuthProvider auth = Provider.of(context, listen: false);
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (ctx, product, _) => Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            color: theme.accentColor,
            onPressed: () {
              product.toggleFavorite(auth.token, auth.userId);
            },
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: theme.accentColor,
            onPressed: () {
              cart.addItem(product);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Produto adicionado com sucesso!'),
                  // backgroundColor: Colors.green,
                  action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () => cart.removeSingleItem(product.id)),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
