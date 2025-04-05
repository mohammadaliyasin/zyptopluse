import 'package:flutter/material.dart';
import 'package:zypto_plus_app/model/crypto_model.dart';

class CryptoCard extends StatelessWidget {
  final CryptoModel crypto;
  final VoidCallback onFavorite;

  const CryptoCard({
    super.key,
    required this.crypto,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(crypto.imageUrl, width: 40, height: 40),
        title: Text(crypto.name),
        subtitle: Text(crypto.symbol.toUpperCase()),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${crypto.currentPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            IconButton(
              icon: const Icon(Icons.star_border),
              onPressed: onFavorite,
            ),
          ],
        ),
      ),
    );
  }
}