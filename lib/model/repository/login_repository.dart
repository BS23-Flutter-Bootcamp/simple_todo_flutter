import 'package:simple_todo_flutter/model/services/login_service.dart';

class LoginRepository {
  final LoginService _loginService;
  LoginRepository(this._loginService);
  get firebaseAuth => _loginService.firebaseAuth;
  Future<void> signIn({required email, required String password}) async {
    try {
      await _loginService.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
