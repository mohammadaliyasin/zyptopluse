class FavoriteModel {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final String imageUrl;
  final String marketCapRank;
  final double priceChangePercentage24h;

  FavoriteModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.imageUrl,
    required this.marketCapRank,
    required this.priceChangePercentage24h,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'].toString(),
      name: json['name'],
      symbol: json['symbol'],
      currentPrice: json['current_price'].toDouble(),
      imageUrl: json['image_url'],
      marketCapRank: json['market_cap_rank'].toString(),
      priceChangePercentage24h: json['price_change_percentage_24h'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'current_price': currentPrice,
      'market_cap_rank': marketCapRank,
      'price_change_percentage_24h': priceChangePercentage24h,
      'image_url': imageUrl,
    };
  }
}