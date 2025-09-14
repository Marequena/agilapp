import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/controllers/sample_controller.dart';
import 'presentation/controllers/auth_controller.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'presentation/pages/design_demo.dart';
import 'presentation/pages/dashboard_demo.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'data/repositories/sample_repository_impl.dart';
import 'domain/usecases/get_items.dart';
import 'core/theme/design_system.dart';
import 'core/theme/color_tokens.dart';

void main() {
  final repo = SampleRepositoryImpl();
  final getItems = GetItems(repo);
  final authRepo = AuthRepositoryImpl();
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => SampleController(getItems)),
      ChangeNotifierProvider(create: (_) => AuthController(authRepo)),
    ],
    child: const AgilApp(),
  ));
}

class AgilApp extends StatelessWidget {
  const AgilApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgilApp',
      theme: AppTheme.light().copyWith(primaryColor: ColorTokens.primarySwatch),
      routes: {
  '/': (_) => const SplashPage(),
  '/design-demo': (_) => const DesignDemoPage(),
  '/dashboard-demo': (_) => const DashboardDemoPage(),
  '/login': (_) => const LoginPage(),
      },
    );
  }
}
