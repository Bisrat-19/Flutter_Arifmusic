import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../config/app_routes.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isObscured = true;
  String _role = 'listener'; // listener | artist

  void _togglePasswordVisibility() =>
      setState(() => _isObscured = !_isObscured);

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await AuthService.register(
        _fullNameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
        _role,
      );

      if (success) {
        // 👉 go to wrapper with bottom navigation
        Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create an account',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('Sign up to get started',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 30),

              // Full name
              TextFormField(
                controller: _fullNameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your full name' : null,
              ),
              const SizedBox(height: 20),

              // Email
              TextFormField(
                controller: _emailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your email' : null,
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _isObscured,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                validator: (v) => v == null || v.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 20),

              // Confirm
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _isObscured,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v != _passwordCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 20),

              // Role selection
              const Text('Register as',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Row(
                children: [
                  Radio<String>(
                    value: 'listener',
                    groupValue: _role,
                    onChanged: (v) => setState(() => _role = v!),
                    activeColor: Colors.green,
                  ),
                  const Text('Listener', style: TextStyle(color: Colors.white)),
                  Radio<String>(
                    value: 'artist',
                    groupValue: _role,
                    onChanged: (v) => setState(() => _role = v!),
                    activeColor: Colors.green,
                  ),
                  const Text('Artist', style: TextStyle(color: Colors.white)),
                ],
              ),
              const Text(
                'Artist accounts require approval from our team',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Create account'),
                ),
              ),
              const SizedBox(height: 20),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?',
                      style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child:
                        const Text('Login', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
