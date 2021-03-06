import 'package:eCommerce/exceptions/http_exception.dart';
import 'package:eCommerce/providers/product.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/utils/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    // titlePadding: const EdgeInsets.only(top: 20, left: 20),
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.warning,
                          color: Theme.of(context).errorColor,
                        ),
                        SizedBox(width: 10),
                        Text('Remover item'),
                      ],
                    ),
                    content: Text('Tem certeza que deseja remover este item?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      FlatButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value) {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .removeProduct(product.id);
                      scaffold.showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Produto removido com sucesso!'),
                      ));
                    } on HttpException catch (error) {
                      scaffold.showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(error.toString()),
                      ));
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
