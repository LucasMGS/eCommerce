import 'package:eCommerce/providers/cart.dart';
import 'package:eCommerce/providers/order_provider.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/utils/appRoutes.dart';
import 'package:eCommerce/views/cart_screen.dart';
import 'package:eCommerce/views/order_screen.dart';
import 'package:eCommerce/views/products_overview_screen.dart';
import 'package:eCommerce/widgets/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new OrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDER: (ctx) => OrderScreen(),
        },
        home: ProductsOverViewScreen(),
      ),
    );
  }
}
