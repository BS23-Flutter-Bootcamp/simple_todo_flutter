import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/firebase_options.dart';
import 'package:simple_todo_flutter/model/repository/notification_repository.dart';
import 'package:simple_todo_flutter/model/repository/task_repository.dart';
import 'package:simple_todo_flutter/model/services/firestore_service.dart';
import 'package:simple_todo_flutter/model/services/task_service.dart';
import 'package:simple_todo_flutter/view/home_screen.dart';
import 'package:simple_todo_flutter/view/splash_screen.dart';
import 'package:simple_todo_flutter/view_model/task_viewmodel.dart';
import 'package:simple_todo_flutter/model/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();
  runApp(
    MultiProvider(
      providers: [
        Provider<TaskRepository>(
          create:
              (_) => TaskRepository(
                TaskService(),
                FirestoreService(),
                NotificationRepository(),
              ),
        ),
        ChangeNotifierProvider<TaskViewModel>(
          create: (context) => TaskViewModel(context.read<TaskRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
      ),

      home:
          FirebaseAuth.instance.currentUser != null
              ? const HomeScreen()
              : const SplashScreen(),
    );
  }
}
