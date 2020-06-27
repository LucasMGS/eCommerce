import 'package:eCommerce/providers/order_provider.dart';
import 'package:eCommerce/widgets/app_drawer.dart';
import 'package:eCommerce/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<OrderProvider>(builder: (ctx, order, child) {
              return ListView.builder(
                itemCount: order.orderCount,
                itemBuilder: (_, i) {
                  return Card(
                    child: OrderWidget(order: order.orders[i]),
                  );
                },
              );
            });
          }
        },
      ),
      //_isLoading == true
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ListView.builder(
      //         itemCount: orderProvider.orderCount,
      //         itemBuilder: (_, i) {
      //           return Card(
      //             child: OrderWidget(order: orderProvider.orders[i]),
      //           );
      //         },
      //       ),
      drawer: AppDrawer(),
    );
  }
}
