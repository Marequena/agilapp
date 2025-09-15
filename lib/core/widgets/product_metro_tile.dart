import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';
import '../theme/color_tokens.dart';

class ProductMetroTile extends StatelessWidget {
  final Product product;
  final double height;
  final VoidCallback? onTap;

  const ProductMetroTile({Key? key, required this.product, this.height = 160, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final color = ColorTokens.primary.withAlpha((0.06 * 255).round());
    final fg = Colors.black87;
    final imageUrl = product.image;
      // determine display price: prefer prices[].preciobase
      String priceLabel = '-';
      try {
        if (product.prices != null && product.prices!.isNotEmpty) {
          final first = product.prices!.first;
          if (first is Map) {
            if (first['selling_price'] != null) {
              priceLabel = first['selling_price'].toString();
            } else if (first['preciobase'] != null) {
              priceLabel = first['preciobase'].toString();
            }
          }
        }
      } catch (_) {}
      if ((priceLabel == '-' || priceLabel.isEmpty) && product.price != null) priceLabel = product.price!;
      final stock = product.stock ?? '-';
  final fmt = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString());

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          height: height,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300))
                      : Container(color: Colors.grey.shade300),
                ),
                // stock badge with animation
                Builder(builder: (ctx) {
                  final stockStr = product.stock ?? '';
                  final stockNum = int.tryParse(stockStr);
                  if (stockNum == null) return const SizedBox.shrink();
                  Color badgeColor = ColorTokens.secondary;
                  if (stockNum <= 0) badgeColor = Colors.red.shade700;
                  else if (stockNum <= 5) badgeColor = Colors.orange.shade700;
                  final badgeLabel = stockNum <= 0 ? 'Agotado' : '$stockNum';
                  return Positioned(
                    right: 6,
                    top: 6,
                    child: AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 350),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(12)),
                        child: Text(badgeLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  );
                })
              ]),
            ),
            const SizedBox(height: 8),
            Text(product.name ?? 'Sin nombre', style: TextStyle(color: fg, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(fmt.format(double.tryParse(priceLabel) ?? 0.0), style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
              Text('stk: $stock', style: TextStyle(color: fg.withAlpha((0.7 * 255).round()), fontSize: 12)),
            ])
          ]),
        ),
      ),
    );
  }
}
