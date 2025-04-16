import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_todo_flutter/view/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
