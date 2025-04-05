import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zypto_plus_app/model/favorite_model.dart';
import '../services/favorite_service.dart';

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  return FavoriteService();
});

class FavoritesNotifier extends StateNotifier<List<FavoriteModel>> {
  final FavoriteService _favoriteService;

  FavoritesNotifier(this._favoriteService) : super([]);

  Future<void> loadFavorites() async {
    try {
      final favorites = await _favoriteService.getFavorites();
      state = favorites;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    try {
      await _favoriteService.addFavorite(favorite);
      await loadFavorites();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFavorite(String id) async {
    try {
      await _favoriteService.deleteFavorite(id);
      state = state.where((fav) => fav.id != id).toList();
    } catch (e) {
      rethrow;
    }
  }

  bool isFavorited(String cryptoId) {
    return state.any((fav) => fav.id == cryptoId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteModel>>((ref) {
  final favoriteService = ref.read(favoriteServiceProvider);
  return FavoritesNotifier(favoriteService);
});

final isFavoritedProvider = Provider.family<bool, String>((ref, cryptoId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.any((fav) => fav.id == cryptoId);
});