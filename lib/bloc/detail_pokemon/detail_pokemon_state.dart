part of 'detail_pokemon_bloc.dart';

@immutable
abstract class DetailPokemonState {}

class DetailPokemonEmpty extends DetailPokemonState {}

class DetailPokemonLoading extends DetailPokemonState {}

class DetailPokemonHasData extends DetailPokemonState {
  final List<FlavorTextEntry> flavorTextEntries;

  DetailPokemonHasData(this.flavorTextEntries);
}

class DetailPokemonError extends DetailPokemonState {
  final String message;

  DetailPokemonError(this.message);
}
