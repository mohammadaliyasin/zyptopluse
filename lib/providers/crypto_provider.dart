import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zypto_plus_app/model/crypto_model.dart';
import '../services/api_service.dart';


final cryptoListProvider = FutureProvider<List<CryptoModel>>((ref) async {
  final apiService = ApiService();
  return await apiService.fetchCryptoData();
});