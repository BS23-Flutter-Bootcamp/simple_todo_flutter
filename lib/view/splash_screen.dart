import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/view/home_screen.dart';
import 'package:simple_todo_flutter/view/login_screen.dart';
import 'package:simple_todo_flutter/view_model/login_viewmodel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        LoginViewModel viewModel = context.read<LoginViewModel>();
        Navigator.pushReplacement(
          context,
          FirebaseAuth.instance.currentUser != null
              ? MaterialPageRoute(builder: (context) => const HomeScreen())
              : MaterialPageRoute(
                builder: (context) => LoginScreen(viewModel: viewModel),
              ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF00695C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xFFFF6E40),
              ),
              padding: const EdgeInsets.all(20),
              child: Lottie.asset(
                'assets/todo_animation.json',
                width: 160,
                height: 150,
              ),
            ),
            const Text(
              'Simple ToDo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
