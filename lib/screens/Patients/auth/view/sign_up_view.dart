import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/auth/controller/sign_up_controller.dart';
import 'package:lottie/lottie.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final SignUpController _controller = SignUpController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _controller.model.email = _emailController.text;
    });
    _passwordController.addListener(() {
      _controller.model.password = _passwordController.text;
    });
    _confirmPasswordController.addListener(() {
      _controller.model.confirmPassword = _confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is now set by the global theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                'assets/animations/sign.json', // You can use a different animation for sign up
                height: 260,
              ),
              const SizedBox(height: 16),
              Text(
                "Create Account",
                textAlign: TextAlign.center,
                // Font is inherited from the global theme
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField('Email', 'username@example.com', _emailController),
              const SizedBox(height: 20),
              _buildTextField('Password', '••••••••', _passwordController,
                  isPassword: true),
              const SizedBox(height: 20),
              _buildTextField('Confirm Password', '••••••••', _confirmPasswordController,
                  isPassword: true),
              const SizedBox(height: 30),
              _buildSignUpButton(context),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate back to the Login screen
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          // Decoration is styled by the global InputDecorationTheme
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: isPassword
                ? Icon(Icons.visibility_off_outlined, color: Colors.grey[600])
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    // This button is styled by the global ElevatedButtonTheme
    return ElevatedButton(
      onPressed: () {
        _controller.signUpWithEmailAndPassword(context);
      },
      child: const Text('Sign Up'),
    );
  }
}
