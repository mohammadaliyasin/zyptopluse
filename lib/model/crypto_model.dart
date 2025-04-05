class CryptoModel {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double currentPrice;
  final double? priceChangePercentage24h;
  final int marketCapRank;

  CryptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currentPrice,
    this.priceChangePercentage24h,
    required this.marketCapRank,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      imageUrl: json['image'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h'] != null
          ? (json['price_change_percentage_24h'] as num).toDouble()
          : null,
      marketCapRank: json['market_cap_rank'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'image': imageUrl,
      'current_price': currentPrice,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap_rank': marketCapRank,
    };
  }
}