import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/view/home_screen.dart';
import 'package:simple_todo_flutter/view/signup_screen.dart';
import 'package:simple_todo_flutter/view/widgets/loading.dart';
import 'package:simple_todo_flutter/view/widgets/login_form_fileds.dart';
import 'package:simple_todo_flutter/view_model/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn(LoginViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await viewModel.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'Login successfully',
                style: const TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.teal,
                ),
              ),
            ),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                viewModel.errorMessage.isNotEmpty
                    ? viewModel.errorMessage
                    : 'Login failed',
                style: const TextStyle(color: Color(0xFFD32F2F)),
              ),
            ),
            backgroundColor: Colors.white,
          ),
        );
      }
    }
  }

  void _handleCreateAccount(LoginViewModel viewModel) {
    if (viewModel.isLoading) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF4DB6AC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LoginFormFields(
                              emailController: emailController,
                              passwordController: passwordController,
                              formKey: _formKey,
                            ),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    widget.viewModel.isLoading
                                        ? null
                                        : () => _handleSignIn(widget.viewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00695C),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child:
                                    widget.viewModel.isLoading
                                        ? Loading()
                                        : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextButton(
                              onPressed:
                                  () => _handleCreateAccount(widget.viewModel),
                              child: const Text(
                                'Not a member? Create account',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
