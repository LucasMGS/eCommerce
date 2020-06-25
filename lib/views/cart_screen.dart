import 'package:eCommerce/providers/cart.dart';
import 'package:eCommerce/providers/order_provider.dart';
import 'package:eCommerce/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.products.values.toList();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$${cart.getTotalAmount}',
                      style: TextStyle(
                        color: theme.primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text(
                      'COMPRAR',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrder(cart);
                      cart.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemCount: cart.productCount,
            itemBuilder: (_, i) {
              return CartItemWidget(
                cartItem: cartItems[i],
              );
            },
          ))
        ],
      ),
    );
  }
}
