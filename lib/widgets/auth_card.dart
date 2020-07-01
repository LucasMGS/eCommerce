import 'package:eCommerce/exceptions/auth_exception.dart';
import 'package:eCommerce/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum AuthMode { SignUp, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          )
        ],
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  var _authMode = AuthMode.Login;
  final _formKey = GlobalKey<FormState>();
  Future<void> _onSubmit() async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState.save();
      AuthProvider auth = Provider.of(context, listen: false);
      if (_authMode == AuthMode.Login) {
        await auth.login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await auth.signUp(
          _authData['email'],
          _authData['password'],
        );
      }
      setState(() {
        _isLoading = false;
      });
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  final _passwordController = TextEditingController();
  bool _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: _authMode == AuthMode.Login ? 290 : 391,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Digite um e-mail válido!';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Digite uma senha válida!';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirmar senha'),
                  validator: _authMode == AuthMode.SignUp
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Senhas são diferentes!';
                          }
                          return null;
                        }
                      : null,
                ),
              SizedBox(height: 20),
              Spacer(),
              _isLoading == true
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                          _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                      color: Theme.of(context).primaryColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                      onPressed: _onSubmit,
                    ),
              FlatButton(
                child: _authMode == AuthMode.Login
                    ? Text('REGISTRAR')
                    : Text('ENTRAR'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _switchAuthMode,
              )
            ],
          ),
        ),
      ),
    );
  }
}
