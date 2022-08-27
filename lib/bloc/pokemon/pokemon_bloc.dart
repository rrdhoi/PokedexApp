import 'package:bloc/bloc.dart';
import 'package:pokedex_app/data/model/pokemon.dart';

import '../../data/network/api_services.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final ApiServices apiServices;

  PokemonBloc(this.apiServices) : super(PokemonInitial()) {
    on<LoadPokemonEvent>(
      (event, emit) async {
        if (state is PokemonInitial) {
          PokemonResponse pokemonResponse =
              await apiServices.getListPokemon(0, 10);

          emit(PokemonLoaded(
              pokemonList: pokemonResponse.listPokemon, hasReachedMax: false));
        } else {
          PokemonLoaded pokemonLoaded = state as PokemonLoaded;
          PokemonResponse pokemonResponse = await apiServices.getListPokemon(
              pokemonLoaded.pokemonList.length, 10);

          emit(
            pokemonResponse.listPokemon.isEmpty
                ? pokemonLoaded.copyWith(hasReachedMax: true)
                : PokemonLoaded(
                    pokemonList: pokemonLoaded.pokemonList +
                        (pokemonResponse.listPokemon),
                    hasReachedMax: false,
                  ),
          );
        }
      },
    );
  }
}
