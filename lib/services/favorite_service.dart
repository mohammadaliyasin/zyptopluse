import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zypto_plus_app/model/favorite_model.dart';

class FavoriteService {
  static const String _baseUrl = 'https://api.fluttercrypto.agpro.co.in';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getAuthHeader() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    return token != null ? 'Bearer $token' : null;
  }

  Future<List<FavoriteModel>> getFavorites() async {
    final authHeader = await _getAuthHeader();
    if (authHeader == null) throw Exception('Not authenticated');

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/items/crypto_favorites'),
        headers: {'Authorization': authHeader},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((json) => FavoriteModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorites: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    final authHeader = await _getAuthHeader();
    if (authHeader == null) throw Exception('Not authenticated');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/items/crypto_favorites'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': favorite.name,
          'symbol': favorite.symbol,
          'current_price': favorite.currentPrice,
          'market_cap_rank': favorite.marketCapRank,
          'price_change_percentage_24h': favorite.priceChangePercentage24h,
          'image_url': favorite.imageUrl,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add favorite: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding favorite: $e');
    }
  }

  Future<void> deleteFavorite(String itemId) async {
    final authHeader = await _getAuthHeader();
    if (authHeader == null) throw Exception('Not authenticated');

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/items/crypto_favorites/$itemId'),
        headers: {'Authorization': authHeader},
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete favorite: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting favorite: $e');
    }
  }
}