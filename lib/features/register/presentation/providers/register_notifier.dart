import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecase/register_usecase.dart';

enum RegisterState { initial, loading, success, error }

class RegisterNotifier extends ChangeNotifier {
  final RegisterUseCase registerUseCase;

  RegisterNotifier({
    required this.registerUseCase,
  });

  RegisterState _state = RegisterState.initial;
  User? _registeredUser;
  String? _errorMessage;
  String? _token;

  RegisterState get state => _state;
  User? get registeredUser => _registeredUser;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  bool get isLoading => _state == RegisterState.loading;

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? lastName,
    String? phone,
  }) async {
    try {
      _state = RegisterState.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await registerUseCase(
        email: email,
        password: password,
        name: name,
        lastName: lastName,
        phone: phone,
      );

      _registeredUser = result.user;
      _token = result.token;
      _state = RegisterState.success;
      notifyListeners();

      return true;
    } catch (e) {
      _state = RegisterState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _state = RegisterState.initial;
    _registeredUser = null;
    _errorMessage = null;
    _token = null;
    notifyListeners();
  }
}
