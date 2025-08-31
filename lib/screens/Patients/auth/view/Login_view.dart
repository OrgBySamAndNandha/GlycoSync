import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
// Make sure these import paths are correct for your project structure
import 'package:glycosync/screens/Patients/auth/controller/Login_controller.dart';
import 'package:glycosync/screens/Patients/auth/view/sign_up_view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _controller.model.email = _emailController.text;
    });
    _passwordController.addListener(() {
      _controller.model.password = _passwordController.text;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is now set by the global theme in app_theme.dart
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                'assets/animations/login.json', // Make sure you have this asset
                height: 250,
              ),
              const SizedBox(height: 16),
              Text(
                "GlycoSync",
                textAlign: TextAlign.center,
                // Font is inherited from the global theme
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField('Email', 'username@example.com', _emailController),
              const SizedBox(height: 20),
              _buildTextField('Password', '••••••••', _passwordController,
                  isPassword: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 16),
              _buildSignInButton(context),
              const SizedBox(height: 16),
              _buildGoogleSignInButton(context),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpView()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // Uses accent color from the theme
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
          // Decoration is now styled by the global InputDecorationTheme
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

  Widget _buildSignInButton(BuildContext context) {
    // This button is styled by the global ElevatedButtonTheme
    return ElevatedButton(
      onPressed: () {
        _controller.signInWithEmailAndPassword(context);
      },
      child: const Text('Sign in'),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    // This button is styled by the global OutlinedButtonTheme
    return OutlinedButton.icon(
      // Make sure you have 'google.png' in your assets folder
      icon: Image.asset('assets/google.png', height: 22.0),
      onPressed: () {
        _controller.signInWithGoogle(context);
      },
      label: const Text('Sign in with Google'),
    );
  }
}
