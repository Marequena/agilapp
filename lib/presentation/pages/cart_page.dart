import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/metro_button.dart';
import '../controllers/cart_controller.dart';
import '../controllers/customer_controller.dart';
import '../../domain/entities/customer.dart';
import '../../data/repositories/sales_repository_impl.dart';
import 'receipt_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CustomerPickerSheet extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSelected;
  const _CustomerPickerSheet({Key? key, required this.onSelected}) : super(key: key);

  @override
  State<_CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<_CustomerPickerSheet> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    // load customers via provider after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final ctrl = Provider.of<CustomerController>(context, listen: false);
        ctrl.load();
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<CustomerController>(context);
    final list = ctrl.customers
        .where((c) => _query.isEmpty || (c.name ?? '').toLowerCase().contains(_query.toLowerCase()) || (c.email ?? '').toLowerCase().contains(_query.toLowerCase()) || (c.contact ?? '').toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.25,
      maxChildSize: 0.95,
      builder: (context, sc) {
        return Container(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
          child: SingleChildScrollView(
            controller: sc,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                const ListTile(title: Text('Seleccionar cliente')),
                TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar por nombre, email o teléfono'), onChanged: (v) => setState(() => _query = v)),
                const SizedBox(height: 12),
                if (ctrl.loading) const Center(child: CircularProgressIndicator()) else ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, idx) {
                    final c = list[idx];
                    return ListTile(
                      title: Text(c.name ?? 'Sin nombre'),
                      subtitle: Text(c.email ?? c.contact ?? ''),
                      onTap: () {
                        // immediately return selected customer and close the sheet
                        widget.onSelected((c).toJson());
                        Navigator.of(context).pop();
                      },
                    );
                  },
                )
              ]),
            ),
          ),
        );
      },
    );
  }

}


class _CartPageState extends State<CartPage> {
  Map<String, dynamic>? _selectedCustomer;

  void _openCustomerPicker(BuildContext context) async {
    // show bottom sheet with customers
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CustomerPickerSheet(onSelected: (c) {
        setState(() {
          _selectedCustomer = c;
        });
        // sheet will close itself; do not pop the route
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    final items = cart.items;
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: items.isEmpty
          ? const Center(child: Text('Carrito vacío'))
          : Column(children: [
              // Customer selection header
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  Expanded(
        child: _selectedCustomer == null
          ? TextButton.icon(onPressed: () => _openCustomerPicker(context), icon: const Icon(Icons.person_search), label: const Text('Seleccionar cliente'))
          : _customerSummaryWidget(_selectedCustomer!),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(onPressed: () => _openCustomerPicker(context), icon: const Icon(Icons.search), label: const Text('Buscar'))
                ]),
              ),
              if (_selectedCustomer != null) const Divider(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, idx) {
                    final it = items[idx];
                    final unitPrice = it.selectedPrice;
                    final subtotal = unitPrice * it.qty;
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(children: [
                          // product avatar / image placeholder
                          if (it.product.image != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.network(it.product.image!, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => CircleAvatar(radius: 28, child: Text(it.product.name?.substring(0, 1) ?? '?'))),
                            ),
                          if (it.product.image == null) CircleAvatar(radius: 28, child: Text(it.product.name?.substring(0, 1) ?? '?')),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(it.product.name ?? 'Sin nombre', style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(it.product.sku ?? '', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text(it.priceLabel ?? cart.formattedCurrency(unitPrice), style: const TextStyle(fontSize: 14, color: Colors.black54)),
                          ])),
                          const SizedBox(width: 8),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text(cart.formattedCurrency(subtotal), style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(children: [
                              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cart.updateQty(it, it.qty - 1)),
                              Text('${it.qty}', style: const TextStyle(fontWeight: FontWeight.w700)),
                              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cart.updateQty(it, it.qty + 1)),
                            ]),
                            const SizedBox(height: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                final removed = cart.removeItem(it);
                                if (removed != null) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Artículo eliminado'),
                                    action: SnackBarAction(label: 'Deshacer', onPressed: () => cart.restoreItem(removed)),
                                    duration: const Duration(seconds: 4),
                                  ));
                                }
                              },
                            ),
                          ])
                        ]),
                      ),
                    );
                  },
                ),
              ),
        Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [
                  BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 8, offset: const Offset(0, -2)),
                ]),
                child: Row(children: [
                  Expanded(
                      child: MetroButton(
                    label: 'Checkout',
                    icon: Icons.shopping_cart_checkout,
                    variant: MetroVariant.success,
                    fullWidth: true,
                    onPressed: () async {
                      final repo = SalesRepositoryImpl();
                      final itemsPayload = cart.items.map((it) => {
                            'product_id': it.product.id,
                            'sku': it.product.sku,
                            'name': it.product.name,
                            'qty': it.qty,
                            'unit_price': it.selectedPrice,
                            'price_label': it.priceLabel,
                          }).toList();
                      final payload = {
                        'customer': _selectedCustomer ?? {},
                        'items': itemsPayload,
                        'total': cart.totalAmount,
                        'total_items': cart.totalItems,
                        'created_at': DateTime.now().toIso8601String(),
                      };

                      // attempt create sale (will enqueue on failure inside repo)
                      final res = await repo.createSale(payload);
                      if (res != null) {
                        final customerName = _selectedCustomer?['name']?.toString() ?? 'Cliente sin seleccionar';
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Venta registrada. Items: ${payload['total_items']} • Total: ${cart.formattedCurrency(payload['total'] as double)} • Cliente: $customerName')));
                      } else {
                        // navigate to simulated receipt for enqueued sale (allow even if no customer selected)
                        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReceiptPage(sale: payload)));
                        // clear cart after showing the ticket
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Venta en cola para sincronizar (offline).')));
                      }
                    },
                  )),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const Text('Total', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    Text(cart.formattedCurrency(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  ])
                ]),
              )
            ]),
    );
  }

  Widget _customerSummaryWidget(Map<String, dynamic> m) {
    // build a Customer object for convenience
    final cust = Customer.fromJson(Map<String, dynamic>.from(m));
    final displayContact = cust.email ?? cust.contact ?? '';
    final balance = cust.companyInfo.balance ?? '-';
    final overdue = cust.companyInfo.overdue ?? '-';

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          CircleAvatar(radius: 26, backgroundColor: Theme.of(context).colorScheme.primary, child: const Icon(Icons.person, color: Colors.white, size: 28)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cust.name ?? 'Sin nombre', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(displayContact, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
            const SizedBox(height: 8),
            Row(children: [
              _summaryBadge('Saldo', balance, Colors.green),
              const SizedBox(width: 8),
              _summaryBadge('Atraso', overdue, Colors.redAccent),
              const SizedBox(width: 8),
              _summaryBadge('Facturas', (cust.invoices.length).toString(), Colors.blueAccent),
            ])
          ])),
          IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _selectedCustomer = null)),
        ]),
      ),
    );
  }

  Widget _summaryBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}
