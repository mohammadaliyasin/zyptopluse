import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zypto_plus_app/model/crypto_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  
  Future<List<CryptoModel>> fetchCryptoData() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1'),
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => CryptoModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load crypto data');
      }
    } catch (e) {
      throw Exception('Error fetching crypto data: $e');
    }
  }
}