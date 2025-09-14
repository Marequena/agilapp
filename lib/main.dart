import 'package:flutter/material.dart';

void main() {
  runApp(const AgilApp());
}

class AgilApp extends StatelessWidget {
  const AgilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgilApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgilApp'),
      ),
      body: const Center(
        child: Text('Bienvenido a AgilApp!'),
      ),
    );
  }
}
