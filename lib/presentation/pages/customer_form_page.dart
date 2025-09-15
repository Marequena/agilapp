import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/customer.dart';
import '../controllers/customer_controller.dart';
import '../../core/theme/color_tokens.dart';

class CustomerFormPage extends StatefulWidget {
  final Customer? customer;
  const CustomerFormPage({Key? key, this.customer}) : super(key: key);

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  late final TextEditingController _name = TextEditingController(text: widget.customer?.name ?? '');
  late final TextEditingController _email = TextEditingController(text: widget.customer?.email ?? '');
  late final TextEditingController _phone = TextEditingController(text: widget.customer?.contact ?? '');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<CustomerController>(context, listen: false);
    final editing = widget.customer != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTokens.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        title: Text(editing ? 'Editar cliente' : 'Agregar cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nombre')),
          const SizedBox(height: 12),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Teléfono')),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () async {
              final payload = {'name': _name.text.trim(), 'email': _email.text.trim(), 'phone': _phone.text.trim()};
              bool ok;
              if (editing) {
                ok = await ctrl.update(widget.customer!.id, payload);
              } else {
                ok = await ctrl.create(payload);
              }
              if (ok) Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Guardado' : 'Error')));
            },
            child: Text(editing ? 'Actualizar' : 'Crear'),
          )
        ]),
      ),
    );
  }
}
