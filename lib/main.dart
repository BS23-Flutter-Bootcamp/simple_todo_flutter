import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 191, 123, 20),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Todo App"),
          backgroundColor: const Color.fromARGB(255, 23, 153, 36),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Flutter Todo App")],
          ),
        ),
      ),
    );
  }
}
