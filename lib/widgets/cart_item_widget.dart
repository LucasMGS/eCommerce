import 'package:eCommerce/models/cartItem.dart';
import 'package:eCommerce/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({Key key, this.cartItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: theme.errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => Provider.of<Cart>(context, listen: false)
          .removeProduct(cartItem.productId),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${cartItem.price}'),
                ),
              ),
            ),
            title: Text(cartItem.title),
            subtitle: Text(
                'Total: ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
