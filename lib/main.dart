import 'package:eCommerce/providers/auth_provider.dart';
import 'package:eCommerce/providers/cart.dart';
import 'package:eCommerce/providers/order_provider.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/utils/appRoutes.dart';
import 'package:eCommerce/views/auth_home_screen.dart';
import 'package:eCommerce/views/auth_screen.dart';
import 'package:eCommerce/views/cart_screen.dart';
import 'package:eCommerce/views/order_screen.dart';
import 'package:eCommerce/views/product_form_screen.dart';

import 'package:eCommerce/views/products_screen.dart';
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
          create: (_) => new AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (_) => new ProductsProvider(),
          update: (ctx, auth, previousProducts) => new ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts.products,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => new OrderProvider(),
          update: (ctx, auth, previousOrders) => new OrderProvider(
            auth.token,
            auth.userId,
            previousOrders.orders,
          ),
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
        home: AuthHomeScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDER: (ctx) => OrderScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
          AppRoutes.AUTH: (ctx) => AuthScreen(),
        },
      ),
    );
  }
}
