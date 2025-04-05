import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:zypto_plus_app/model/favorite_model.dart';
import 'package:zypto_plus_app/providers/crypto_provider.dart';
import 'package:zypto_plus_app/providers/favorites_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedChartDays = 1;

  @override
  Widget build(BuildContext context) {
    final cryptoListAsync = ref.watch(cryptoListProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xff1B232A),
      appBar: AppBar(
        backgroundColor: const Color(0xff1B232A),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xff5ED5A8),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xff5ED5A8)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: Color(0xff5ED5A8)),
            onPressed: () => print('Scanner clicked'),
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xff5ED5A8)),
            onPressed: () {},
          ),
        ],
      ),
      body: cryptoListAsync.when(
        loading:
            () => Center(
              child: CircularProgressIndicator(color: Color(0xff5ED5A8)),
            ),
        error:
            (error, stack) => Center(
              child: Text(
                'Error: $error',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
        data:
            (cryptos) => RefreshIndicator(
              onRefresh: () => ref.refresh(cryptoListProvider.future),
              color: theme.primaryColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: cryptos.length,
                itemBuilder: (context, index) {
                  final crypto = cryptos[index];
                  final isPositive =
                      (crypto.priceChangePercentage24h ?? 0) >= 0;
                  final isFavorited = ref.watch(isFavoritedProvider(crypto.id));

                  return Card(
                    color: const Color.fromARGB(255, 180, 246, 221),
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Leading icon/avatar
                          CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 20,
                            child:
                                crypto.imageUrl.isNotEmpty
                                    ? Image.network(
                                      crypto.imageUrl,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.currency_bitcoin,
                                          color: Color(0xff5ED5A8),
                                        );
                                      },
                                    )
                                    : Icon(
                                      Icons.currency_bitcoin,
                                      color: Color(0xff5ED5A8),
                                    ),
                          ),
                          const SizedBox(width: 12),

                          // Name and symbol
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  crypto.name,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  crypto.symbol.toUpperCase(),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),

                          // Mini chart
                          Container(
                            width: 80,
                            height: 40,
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: 4,
                                minY: crypto.currentPrice * 0.98,
                                maxY: crypto.currentPrice * 1.02,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, crypto.currentPrice * 0.99),
                                      FlSpot(1, crypto.currentPrice * 1.005),
                                      FlSpot(2, crypto.currentPrice * 0.995),
                                      FlSpot(3, crypto.currentPrice * 1.01),
                                      FlSpot(4, crypto.currentPrice),
                                    ],
                                    isCurved: true,
                                    color:
                                        isPositive
                                            ? Color(0xff5ED5A8)
                                            : theme.colorScheme.error,
                                    barWidth: 2,
                                    belowBarData: BarAreaData(show: false),
                                    dotData: FlDotData(show: false),
                                  ),
                                ],
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(show: false),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Price and percentage
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${crypto.currentPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyLarge,
                              ),
                              Text(
                                '${isPositive ? '+' : ''}${crypto.priceChangePercentage24h?.toStringAsFixed(2) ?? '0.00'}%',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color:
                                      isPositive
                                          ? Color.fromARGB(255, 5, 161, 101)
                                          : theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ),

                          // Favorite icon
                          IconButton(
                            icon: Icon(
                              isFavorited ? Icons.star : Icons.star_border,
                              color:
                                  isFavorited
                                      ? Colors.amber
                                      : theme.textTheme.bodyMedium?.color,
                            ),
                            onPressed: () async {
                              if (isFavorited) {
                                await favoritesNotifier.deleteFavorite(
                                  crypto.id,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Removed from favorites',
                                    ),
                                    backgroundColor: theme.primaryColor,
                                  ),
                                );
                              } else {
                                await favoritesNotifier.addFavorite(
                                  FavoriteModel(
                                    id: crypto.id,
                                    name: crypto.name,
                                    symbol: crypto.symbol,
                                    currentPrice: crypto.currentPrice,
                                    imageUrl: crypto.imageUrl,
                                    marketCapRank:
                                        crypto.marketCapRank.toString(),
                                    priceChangePercentage24h:
                                        crypto.priceChangePercentage24h ?? 0.0,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Added to favorites'),
                                    backgroundColor: Color(0xff5ED5A8),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
          currentIndex: 0,
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
