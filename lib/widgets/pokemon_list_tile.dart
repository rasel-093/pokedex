import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'pokemon_stats_card.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonurl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemons;
  PokemonListTile({super.key, required this.pokemonurl});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonurl));

    return pokemon.when(
      data: (data) {
        return _tile(context, false, data);
      },
      error: (error, stackTrace) {
        return Text('Error: $error');
      },
      loading: () {
        return _tile(context, true, null);
      },
    );
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCard(pokemonUrl: pokemonurl);
              },
            );
          }
        },
        child: ListTile(
          leading:
              pokemon != null
                  ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      pokemon.sprites!.frontDefault!,
                    ),
                  )
                  : CircleAvatar(),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : 'Pokemon name is loading....',
          ),
          subtitle: Text('Has ${pokemon?.moves?.length.toString() ?? 0} moves'),
          trailing: IconButton(
            onPressed: () {
              if (_favoritePokemons.contains(pokemonurl)) {
                _favoritePokemonsProvider.removeFavoritePokeman(pokemonurl);
              } else {
                _favoritePokemonsProvider.addFavoritePokeman(pokemonurl);
              }
            },
            icon: Icon(
              _favoritePokemons.contains(pokemonurl)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
