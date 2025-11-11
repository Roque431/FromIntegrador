import 'package:flutter/foundation.dart';
import '../../domain/usecase/send_verification_code_usecase.dart';
import '../../domain/usecase/verify_email_usecase.dart';

enum VerifyEmailState { initial, loading, codeSent, verified, error }

class VerifyEmailNotifier extends ChangeNotifier {
  final SendVerificationCodeUseCase sendVerificationCodeUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;

  VerifyEmailNotifier({
    required this.sendVerificationCodeUseCase,
    required this.verifyEmailUseCase,
  });

  VerifyEmailState _state = VerifyEmailState.initial;
  String? _errorMessage;
  String? _successMessage;

  VerifyEmailState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isLoading => _state == VerifyEmailState.loading;

  Future<bool> sendVerificationCode(String email) async {
    try {
      _state = VerifyEmailState.loading;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();

      final message = await sendVerificationCodeUseCase(email);

      _successMessage = message;
      _state = VerifyEmailState.codeSent;
      notifyListeners();

      return true;
    } catch (e) {
      _state = VerifyEmailState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    try {
      _state = VerifyEmailState.loading;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();

      final message = await verifyEmailUseCase(email, code);

      _successMessage = message;
      _state = VerifyEmailState.verified;
      notifyListeners();

      return true;
    } catch (e) {
      _state = VerifyEmailState.error;
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
    _state = VerifyEmailState.initial;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
