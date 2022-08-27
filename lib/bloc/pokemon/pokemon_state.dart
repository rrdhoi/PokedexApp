part of 'pokemon_bloc.dart';

abstract class PokemonState {}

class PokemonInitial extends PokemonState {}

class PokemonLoaded extends PokemonState {
  List<Pokemon> pokemonList;
  bool hasReachedMax;

  PokemonLoaded({required this.pokemonList, required this.hasReachedMax});

  PokemonLoaded copyWith({
    List<Pokemon>? pokemonList,
    bool? hasReachedMax,
  }) {
    return PokemonLoaded(
      pokemonList: pokemonList ?? this.pokemonList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
