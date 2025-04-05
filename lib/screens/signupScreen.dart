import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:zypto_plus_app/widgets/authToggel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("https://api.fluttercrypto.agpro.co.in/users"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
          "first_name": name,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage("Account created successfully");
      } else {
        final data = jsonDecode(response.body);
        if (data['errors'] != null &&
            data['errors'][0]['message'].contains('unique')) {
          _showMessage("Email already exists. Try logging in.");
        } else {
          _showMessage(
            "Signup failed: ${data['errors']?[0]['message'] ?? 'Unknown error'}",
          );
        }
      }
    } catch (e) {
      _showMessage("Error: $e");
    }

    setState(() => _isLoading = false);

    context.go('/welcome');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B232A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                AuthToggle(selectedIndex: 1),
                const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField("Name", "Enter your name", _nameController),
                const SizedBox(height: 20),
                _buildTextField("Email", "Enter your email", _emailController),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5ED5A8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff171D22),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xffA7AFB7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xff777777),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: const Color(0xff161C22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: Color(0xffA7AFB7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: const TextStyle(
              color: Color(0xff777777),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: const Color(0xff161C22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
