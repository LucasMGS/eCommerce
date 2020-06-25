import 'package:eCommerce/providers/order_provider.dart';
import 'package:eCommerce/widgets/app_drawer.dart';
import 'package:eCommerce/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orderProvider.orderCount,
        itemBuilder: (_, i) {
          return Card(
            child: OrderWidget(order: orderProvider.orders[i]),
          );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
