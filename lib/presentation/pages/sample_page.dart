import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/sample_controller.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Provider.of<SampleController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sample')),
      body: c.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: c.items.length,
              itemBuilder: (ctx, i) => ListTile(title: Text(c.items[i].title)),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => c.load(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
