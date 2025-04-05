import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zypto_plus_app/providers/favorites_provider.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesProvider.notifier).loadFavorites();
    });
  }

  Future<void> _refreshFavorites() async {
    await ref.read(favoritesProvider.notifier).loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xff1B232A),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xff5ED5A8),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xff5ED5A8)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Color(0xff5ED5A8)),
            onPressed: () {
              print('Scanner clicked');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xff5ED5A8)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Text(
              'Favourites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshFavorites,
              color: const Color(0xff5ED5A8),
              child:
                  favorites.isEmpty
                      ? const Center(
                        child: Text(
                          'No favorites yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(2),
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final favorite = favorites[index];
                          final isPositive =
                              (favorite.priceChangePercentage24h ?? 0) >= 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B232A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                radius: 24,
                                child:
                                    favorite.imageUrl.isNotEmpty
                                        ? Image.network(
                                          favorite.imageUrl,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.currency_bitcoin,
                                              color: Colors.white,
                                            );
                                          },
                                        )
                                        : const Icon(
                                          Icons.currency_bitcoin,
                                          color: Colors.white,
                                        ),
                              ),
                              title: Text(
                                favorite.symbol.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Market Cap Rank: ${favorite.marketCapRank}',
                                    style: const TextStyle(
                                      color: Color(0xff777777),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Price',
                                        style: TextStyle(
                                          color: Color(0xff777777),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '\$${favorite.currentPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color:
                                              isPositive
                                                  ? const Color(0xff5ED5A8)
                                                  : const Color(0xffFF4B4B),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '24h Change',
                                        style: TextStyle(
                                          color: Color(0xff777777),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${isPositive ? '+' : ''}${favorite.priceChangePercentage24h?.toStringAsFixed(2) ?? '0.00'}%',
                                        style: TextStyle(
                                          color:
                                              isPositive
                                                  ? const Color(0xff5ED5A8)
                                                  : const Color(0xffFF4B4B),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xffFF4B4B),
                                ),
                                onPressed: () async {
                                  try {
                                    await favoritesNotifier.deleteFavorite(
                                      favorite.id,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Removed from favorites'),
                                        backgroundColor: Color(0xff5ED5A8),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: const Color(
                                          0xffFF4B4B,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B232A),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xff5ED5A8),
          unselectedItemColor: const Color(0xff777777),
          currentIndex: 3,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          elevation: 0,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/markets');
                break;
              case 2:
                context.go('/trades');
                break;
              case 3:
                context.go('/favorites');
                break;
              case 4:
                context.go('/wallets');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_rounded),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange_sharp),
              label: 'Trades',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Wallets',
            ),
          ],
        ),
      ),
    );
  }
}
