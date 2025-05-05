import 'package:flutter/foundation.dart';
import 'package:simple_todo_flutter/model/repository/login_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this.loginRepository);

  final LoginRepository loginRepository;

  bool _isLoading = false;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await loginRepository.signIn(email: email, password: password);
      final userId = loginRepository.firebaseAuth.currentUser?.uid;
      if (userId == null) {
        setErrorMessage('Failed to retrieve user ID after login');
      }
    } catch (e) {
      setErrorMessage('Failed to sign in: $e');
      throw 'Failed to sign in: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
