import 'package:flutter/cupertino.dart';

class LoginViewModel extends ChangeNotifier {

  bool _isLoggedIn = false ;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void checkLogin(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}