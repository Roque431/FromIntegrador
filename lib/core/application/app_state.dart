import 'package:flutter/material.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AppState extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.checking;
  
  AuthStatus get authStatus => _authStatus;
  bool get isAuthenticated => _authStatus == AuthStatus.authenticated;

  Future<void> checkAuthStatus() async {
    // TODO: Implementar verificación real de autenticación
    _authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }

  void login() {
    _authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }
}