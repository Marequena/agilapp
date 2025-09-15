import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/controllers/sample_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/data/local_storage.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/customer_controller.dart';
import 'presentation/controllers/product_controller.dart';
import 'presentation/controllers/cart_controller.dart';
import 'domain/usecases/get_customers.dart';
import 'data/repositories/customer_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'domain/usecases/get_categories.dart';
import 'presentation/controllers/category_controller.dart';
import 'presentation/pages/design_demo.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/customers_list_page.dart';
import 'presentation/pages/products_list_page.dart';
import 'presentation/pages/sales_page.dart';
import 'presentation/pages/cart_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/customer_form_page.dart';
import 'data/repositories/sample_repository_impl.dart';
import 'domain/usecases/get_items.dart';
import 'core/theme/design_system.dart';
import 'core/theme/color_tokens.dart';
import 'core/services/sync_service.dart';
import 'presentation/pages/sales_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // open minimal boxes used by the app
  await LocalStorage.openBox(LocalStorage.customersBox);
  await LocalStorage.openBox(LocalStorage.productsBox);
  await LocalStorage.openBox(LocalStorage.categoriesBox);
  await LocalStorage.openBox(LocalStorage.pendingBox);
  // continue with existing setup and then start the app
  final repo = SampleRepositoryImpl();
  final getItems = GetItems(repo);
  final authRepo = AuthRepositoryImpl();
  // customers
  final customerRepo = CustomerRepositoryImpl();
  final getCustomers = GetCustomers(customerRepo);
  // products
  final productRepo = ProductRepositoryImpl();
  // categories
  final categoryRepo = CategoryRepositoryImpl();
  final getCategories = GetCategories(categoryRepo);
  // start background sync service
  await SyncService().start();
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => SampleController(getItems)),
      ChangeNotifierProvider(create: (_) => AuthController(authRepo)),
      ChangeNotifierProvider(create: (_) => CustomerController(getCustomers, customerRepo)),
  ChangeNotifierProvider(create: (_) => ProductController(productRepo)),
      ChangeNotifierProvider(create: (_) => CategoryController(getCategories, categoryRepo)),
  ChangeNotifierProvider(create: (_) => CartController()),
    ],
    child: const AgilApp(),
  ));

}

class AgilApp extends StatelessWidget {
  const AgilApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorTokens.toColorScheme(Brightness.light);
    final darkScheme = ColorTokens.toColorScheme(Brightness.dark);

    return MaterialApp(
      title: 'AgilApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(colorScheme: lightScheme, textTheme: AppTheme.light().textTheme),
      darkTheme: ThemeData.from(colorScheme: darkScheme, textTheme: AppTheme.dark().textTheme),
    routes: {
  '/': (_) => const SplashPage(),
  '/design-demo': (_) => const DesignDemoPage(),
  '/dashboard': (_) => const DashboardPage(),
  '/login': (_) => const LoginPage(),
  '/customers': (_) => const CustomersListPage(),
  '/customers/new': (_) => const CustomerFormPage(),
  '/products': (_) => const ProductsListPage(),
  '/sales': (_) => const SalesPage(),
  '/sales_history': (_) => const SalesHistoryPage(),
  '/cart': (_) => const CartPage(),
    '/settings': (_) => const SettingsPage(),
    },
    );
  }
}
