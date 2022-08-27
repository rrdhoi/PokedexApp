import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pokedex_app/data/network/api_services.dart';

import '../../data/model/pokemon_detail.dart';

part 'detail_pokemon_event.dart';
part 'detail_pokemon_state.dart';

class DetailPokemonBloc extends Bloc<DetailPokemonEvent, DetailPokemonState> {
  final ApiServices apiServices;

  DetailPokemonBloc(this.apiServices) : super(DetailPokemonEmpty()) {
    on<LoadDetailPokemonEvent>((event, emit) async {
      emit(DetailPokemonLoading());
      await apiServices
          .detailPokemon(event.id)
          .then((value) => emit(DetailPokemonHasData(value.flavorTextEntries)))
          .catchError((error) => emit(DetailPokemonError(error.toString())));
    });
  }
}
