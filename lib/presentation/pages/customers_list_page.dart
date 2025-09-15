import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/customer.dart';
import '../controllers/customer_controller.dart';
import 'package:agilapp/presentation/pages/customer_form_page.dart';
import '../../core/theme/color_tokens.dart';

class CustomersListPage extends StatefulWidget {
  const CustomersListPage({Key? key}) : super(key: key);

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<CustomerController>(context, listen: false).load());
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<CustomerController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTokens.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CustomerFormPage())),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<CustomerController>(context, listen: false).load(),
        child: Builder(builder: (_) {
          if (ctrl.loading) return const Center(child: CircularProgressIndicator());
          if (ctrl.error != null) {
            return ListView(children: [
              const SizedBox(height: 80),
              Center(child: Text('Error al cargar:')),
              Center(child: Text(ctrl.error!)),
              const SizedBox(height: 12),
              Center(child: ElevatedButton(onPressed: () => ctrl.load(), child: const Text('Reintentar'))),
              const SizedBox(height: 12),
              Center(
                  child: OutlinedButton(
                onPressed: () async {
                  try {
                    final raw = await ctrl.fetchRaw();
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(title: const Text('Raw response'), content: SingleChildScrollView(child: Text(raw.toString())), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))]));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: const Text('Ver respuesta cruda'),
              ))
            ]);
          }

          if (ctrl.customers.isEmpty) {
            return ListView(children: [
              const SizedBox(height: 80),
              const Center(child: Text('No hay clientes')), 
              const SizedBox(height: 12),
              Center(child: ElevatedButton(onPressed: () => ctrl.load(), child: const Text('Cargar'))),
              const SizedBox(height: 12),
              Center(
                  child: OutlinedButton(
                onPressed: () async {
                  try {
                    final raw = await ctrl.fetchRaw();
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(title: const Text('Raw response'), content: SingleChildScrollView(child: Text(raw.toString())), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))]));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: const Text('Ver respuesta cruda'),
              ))
            ]);
          }

          return ListView.separated(
            itemCount: ctrl.customers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final c = ctrl.customers[index];
              final displayContact = c.email ?? c.contact ?? 'Sin contacto';
              final balance = c.companyInfo.balance ?? '-';
              final overdue = c.companyInfo.overdue ?? '-';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showInvoicesSheet(context, c),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: ColorTokens.primary,
                            child: const Icon(Icons.person, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name ?? 'Sin nombre', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                Text(displayContact, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                                const SizedBox(height: 8),
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.green.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                                    child: Text('Saldo: $balance', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.redAccent.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                                    child: Text('Atraso: $overdue', style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
                                  ),
                                ])
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.edit, color: ColorTokens.primary),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomerFormPage(customer: c))),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showInvoicesSheet(BuildContext context, Customer c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.35,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  // drag handle
                  Container(width: 48, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(height: 12),

                  // Header: name, contact and quick actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 28, backgroundColor: ColorTokens.primary, child: const Icon(Icons.person, color: Colors.white)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c.name ?? 'Sin nombre', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(c.email ?? c.contact ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                          ]),
                        ),
                        IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomerFormPage(customer: c))), icon: Icon(Icons.edit, color: ColorTokens.primary))
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Summary badges (balance / overdue / total invoices)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _summaryBadge('Saldo', c.companyInfo.balance ?? '-', Colors.green),
                        const SizedBox(width: 8),
                        _summaryBadge('Atraso', c.companyInfo.overdue ?? '-', Colors.redAccent),
                        const SizedBox(width: 8),
                        _summaryBadge('Facturas', (c.invoices.length).toString(), Colors.blueAccent),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Invoice list or empty state
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: c.invoices.isEmpty
                          ? Center(
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                const Icon(Icons.receipt_long, size: 56, color: Colors.grey),
                                const SizedBox(height: 8),
                                const Text('No hay facturas', style: TextStyle(fontSize: 16, color: Colors.black54)),
                                const SizedBox(height: 8),
                                ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))
                              ]),
                            )
                          : ListView.separated(
                              controller: controller,
                              itemCount: c.invoices.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                final inv = c.invoices[idx];
                                final status = (inv.status ?? '').toLowerCase();
                                final statusColor = status.contains('paid') ? Colors.green : (status.contains('overdue') ? Colors.redAccent : Colors.orange);
                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    leading: CircleAvatar(backgroundColor: statusColor.withAlpha(40), child: Icon(Icons.description, color: statusColor)),
                                    title: Text(inv.invoiceId ?? '—', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    subtitle: Text('Emitida: ${inv.issueDate ?? '-'} • Vence: ${inv.dueDate ?? '-'}'),
                                    trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                      Text(inv.dueAmount ?? '-', style: const TextStyle(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 6),
                                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withAlpha(30), borderRadius: BorderRadius.circular(12)), child: Text(inv.status ?? '-', style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w700)))
                                    ]),
                                    onTap: () {
                                      // Placeholder: could open invoice detail
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
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
