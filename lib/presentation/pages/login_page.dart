import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/metro_background.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

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
      body: Stack(children: [
        const MetroBackground(),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('AgilApp', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('Accede a tu cuenta', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 18),
                    AppInput(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    AppInput(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: _obscure,
                      suffix: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 18),
                    auth.loading
                        ? const SizedBox(height: 44, child: Center(child: CircularProgressIndicator()))
                        : SizedBox(
                            width: double.infinity,
                            child: AppButton(
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
                            ),
                          ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
