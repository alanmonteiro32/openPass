import 'package:shared_preferences/shared_preferences.dart';

abstract class CharacterLocalDataSource {
  Future<bool> toggleFavorite(String url);
  Future<List<String>> getFavorites();
}

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  CharacterLocalDataSourceImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;
  static const String favoritesKey = 'FAVORITES_KEY';

  @override
  Future<bool> toggleFavorite(String url) async {
    final favorites = await getFavorites();

    if (favorites.contains(url)) {
      favorites.remove(url);
    } else {
      favorites.add(url);
    }

    return sharedPreferences.setStringList(favoritesKey, favorites);
  }

  @override
  Future<List<String>> getFavorites() async {
    return sharedPreferences.getStringList(favoritesKey) ?? [];
  }
}
