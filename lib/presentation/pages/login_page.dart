import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_input.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          AppInput(label: 'Email', controller: _emailController),
          const SizedBox(height: 12),
          AppInput(label: 'Password', controller: _passwordController),
          const SizedBox(height: 20),
          auth.loading
              ? const CircularProgressIndicator()
              : AppButton(
                  label: 'Entrar',
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    if (email.isEmpty || !email.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email invalido')));
                      return;
                    }
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password requerido')));
                      return;
                    }

                    final success = await auth.login(email, password);
                    if (success) {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
                    }
                  },
                )
        ]),
      ),
    );
  }
}
