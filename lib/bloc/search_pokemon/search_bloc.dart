import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pokedex_app/data/model/pokemon.dart';
import 'package:pokedex_app/data/network/api_services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  ApiServices apiServices;

  SearchBloc(this.apiServices) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;
      emit(SearchLoading());
      await apiServices
          .searchPokemon(query)
          .then((value) => emit(SearchHasData(value)))
          .catchError((error) => emit(SearchError(error.toString())));
    });
  }
}
