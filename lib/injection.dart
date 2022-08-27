import 'package:get_it/get_it.dart';
import 'package:pokedex_app/bloc/detail_pokemon/detail_pokemon_bloc.dart';
import 'package:pokedex_app/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokedex_app/bloc/search_pokemon/search_bloc.dart';

import 'data/network/api_services.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiServices());
  locator
      .registerFactory(() => PokemonBloc(locator())..add(LoadPokemonEvent()));
  locator.registerFactory(() => SearchBloc(locator()));
  locator.registerFactory(() => DetailPokemonBloc(locator()));
}
