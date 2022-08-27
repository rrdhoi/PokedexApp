part of 'detail_pokemon_bloc.dart';

abstract class DetailPokemonEvent {}

class LoadDetailPokemonEvent extends DetailPokemonEvent {
  String id = '';

  LoadDetailPokemonEvent({required this.id});
}
