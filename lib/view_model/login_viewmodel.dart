import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/model/repository/login_repository.dart';
import 'package:simple_todo_flutter/view/home_screen.dart';
import 'package:simple_todo_flutter/view/signup_screen.dart';
import 'package:simple_todo_flutter/view_model/task_viewmodel.dart';

class LoginViewModel {
  LoginViewModel(this.authRepository);
  final LoginRepository authRepository;
  String? errorMessage;

  Future<void> signIn({
    required BuildContext context,
    required Function setState,
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw 'Please enter email and password';
      }
      if (!email.contains('@')) {
        throw 'Please enter a valid email';
      }
      await authRepository.signIn(email: email, password: password);
      if (context.mounted) {
        final viewModel = Provider.of<TaskViewModel>(context, listen: false);
        final userId = authRepository.firebaseAuth.currentUser?.uid;
        if (userId != null) {
          try {
            await viewModel.onUserLogin(userId);
          } catch (e) {
            if (kDebugMode) {
              print('Error fetching tasks: $e');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Logged in, but failed to fetch tasks.',
                  style: const TextStyle(color: Color(0xFFD32F2F)),
                ),
                backgroundColor: Colors.white,
              ),
            );
          }
        } else {
          throw 'Failed to retrieve user ID after login';
        }
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Sign-in failed: $e');
      }
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage ?? 'Login failed',
            style: const TextStyle(color: Color(0xFFD32F2F)),
          ),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  void onCreateAccountTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
}
