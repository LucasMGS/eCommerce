import 'package:eCommerce/providers/auth_provider.dart';
import 'package:eCommerce/views/auth_screen.dart';
import 'package:eCommerce/views/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);
    print(auth.userLoggedIn);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        } else {
          return auth.userLoggedIn ? ProductsOverViewScreen() : AuthScreen();
        }
      },
    );
  }
}
