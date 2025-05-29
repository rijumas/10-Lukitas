import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Por favor completa todos los campos');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final json = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && json['status'] == true) {
        final token = json['token'];
        final name = json['name'];
        final userId = json['userId'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('userId', userId);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home'); // o dashboard
      } else {
        setState(() => errorMessage = json['message'] ?? 'Credenciales inválidas');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error de red: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/Dina-Boluarte-10-Soles.jpg'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 16),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: loginUser,
                        child: const Text('Sign In'),
                      ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Google'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Forgot Password?'),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
