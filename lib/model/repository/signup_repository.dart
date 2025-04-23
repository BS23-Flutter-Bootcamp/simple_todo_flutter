import 'package:simple_todo_flutter/model/services/signup_service.dart';

class SignupRepository {
  final SignupService _signupService;
  SignupRepository(this._signupService);
  Future<void> signUp({required email, required String password}) async {
    try {
      await _signupService.signUpWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
