import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/http_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>((
  ref,
  url,
) async {
  HttpService _httpService = GetIt.instance.get<HttpService>();
  Response? response = await _httpService.get(url);
  if (response != null && response.statusCode == 200) {
    return Pokemon.fromJson(response.data);
  }
  return null;
});

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
      return FavoritePokemonsProvider([]);
    });
String FAVORITE_POKEMON_LIST_KEY = "FAVORITE_POKEMON_LIST_KEY";

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();
  FavoritePokemonsProvider(super._state) {
    _setup();
  }
  Future<void> _setup() async {
    List<String>? result = await _databaseService.getList(
      FAVORITE_POKEMON_LIST_KEY,
    );
    state = result ?? [];
  }

  void addFavoritePokeman(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }

  void removeFavoritePokeman(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }
}
