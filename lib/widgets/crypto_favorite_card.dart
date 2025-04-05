import 'package:flutter/material.dart';
import 'package:zypto_plus_app/model/favorite_model.dart';

class CryptoFavoritesCard extends StatelessWidget {
  final FavoriteModel favorite;
  final VoidCallback onDelete;

  const CryptoFavoritesCard({
    super.key,
    required this.favorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(favorite.imageUrl, width: 40, height: 40),
        title: Text(favorite.name),
        subtitle: Text(favorite.symbol.toUpperCase()),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${favorite.currentPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}