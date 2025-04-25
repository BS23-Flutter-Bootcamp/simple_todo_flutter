import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/model/repository/signup_repository.dart';
import 'package:simple_todo_flutter/view/login_screen.dart';
import 'package:simple_todo_flutter/view_model/task_viewmodel.dart';

class SignUpViewModel {
  SignUpViewModel(this.authRepository);
  final SignupRepository authRepository;
  String? errorMessage;

  Future<void> signUp({
    required BuildContext context,
    required Function setState,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (username.isEmpty) {
        throw 'Please enter a username';
      }
      if (!email.contains('@')) {
        throw 'Please enter a valid email';
      }
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }
      if (password != confirmPassword) {
        throw 'Passwords do not match';
      }
      if (email.isEmpty || password.isEmpty) {
        throw 'Please enter email and password';
      }

      await authRepository.signUp(email: email, password: password);

      final userId = authRepository.firebaseAuth.currentUser?.uid;
      if (userId != null) {
        final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
        await taskViewModel.onUserLogin(userId);
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage ?? 'Sign-up failed',
            style: const TextStyle(color: Color(0xFFD32F2F)),
          ),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  void onLoginTapped(BuildContext context) {
    Navigator.pop(context);
  }
}