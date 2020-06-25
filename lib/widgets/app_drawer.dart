import 'package:eCommerce/utils/appRoutes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Bem vindo Usuário!'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.ORDER),
          ),
        ],
      ),
    );
  }
}
