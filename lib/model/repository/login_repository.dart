import 'package:simple_todo_flutter/model/services/login_service.dart';

class LoginRepository {
  LoginRepository({required this.loginService});

  final LoginService loginService;

  get firebaseAuth => loginService.firebaseAuth;
  Future<void> signIn({required email, required String password}) async {
    try {
      await loginService.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
