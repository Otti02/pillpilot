import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../theme/app_theme.dart';
import '../router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Simple navigation to home without validation or service calls
    AppRouter.instance.goToHome();
  }

  void _goToRegister() {
    AppRouter.instance.goToRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication,
                  size: 50,
                  color: AppTheme.cardBackgroundColor,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),

              const SizedBox(height: 32),

              // Email Field
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
              ),

              const SizedBox(height: 16),

              // Password Field
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordController,
                obscureText: true,
              ),

              const SizedBox(height: 24),

              // Login Button
              CustomButton(
                text: 'Login',
                onPressed: _login,
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Register Link
              TextButton(
                onPressed: _goToRegister,
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
