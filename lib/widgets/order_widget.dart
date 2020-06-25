import 'package:eCommerce/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({Key key, this.order}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          margin: const EdgeInsets.all(10),
          elevation: 0,
          child: ListTile(
            title: Text('R\$ ${widget.order.total}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: (widget.order.products.length * 25.0) + 10,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: ListView(
              children: widget.order.products.map(
                (product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${product.quantity} x ${product.price}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
      ],
    );
  }
}
