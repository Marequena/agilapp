import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/controllers/sample_controller.dart';
import 'presentation/pages/sample_page.dart';
import 'presentation/pages/design_demo.dart';
import 'presentation/pages/dashboard_demo.dart';
import 'data/repositories/sample_repository_impl.dart';
import 'domain/usecases/get_items.dart';
import 'core/theme/design_system.dart';
import 'core/theme/color_tokens.dart';

void main() {
  final repo = SampleRepositoryImpl();
  final getItems = GetItems(repo);
  runApp(Provider(
    create: (_) => SampleController(getItems),
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
        '/': (_) => const SamplePage(),
  '/design-demo': (_) => const DesignDemoPage(),
  '/dashboard-demo': (_) => const DashboardDemoPage(),
      },
    );
  }
}
