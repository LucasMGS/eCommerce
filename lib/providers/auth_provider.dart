import 'dart:async';
import 'dart:convert';

import 'package:eCommerce/data/store.dart';
import 'package:eCommerce/exceptions/auth_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expireToken;
  Timer _logOutTimer;

  String get token {
    if (_token != null &&
        _expireToken != null &&
        _expireToken.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  bool get userLoggedIn => _token != null;

  String get userId {
    return userLoggedIn ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD-ajD8UBxD-ab2-mZwQ70a3mmINat_FZY';

    final response = await http.post(
      _url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody["error"]["message"]);
    }
    _token = responseBody["idToken"];
    _userId = responseBody["localId"];
    _expireToken = DateTime.now().add(
      Duration(
        seconds: int.parse(responseBody["expiresIn"]),
      ),
    );
    _autoLogOut();

    Store.saveMap('userData', {
      'token': _token,
      'userId': _userId,
      'expireToken': _expireToken.toIso8601String(),
    });
    notifyListeners();
    return Future.value();
  }

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expireToken = null;
    if (_logOutTimer != null) {
      _logOutTimer.cancel();
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogOut() {
    if (_logOutTimer != null) {
      _logOutTimer.cancel();
    }
    final timeToLogOut = _expireToken.difference(DateTime.now()).inSeconds;
    _logOutTimer = Timer(Duration(seconds: timeToLogOut), logOut);
  }

  Future<void> tryAutoLogin() async {
    if (userLoggedIn) {
      print('entrou');
      return Future.value();
    }
    final userData = await Store.getMap('userData');
    if (userData == null) {
      return Future.value();
    }
    final expireToken = DateTime.parse(userData["expireToken"]);
    if (expireToken.isBefore(DateTime.now())) {
      return Future.value();
    }
    print(userData);
    _token = userData["token"];
    _userId = userData["userId"];
    _expireToken = expireToken;

    _autoLogOut();

    notifyListeners();
    return Future.value();
  }
}
