part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchHasData extends SearchState {
  final Pokemon pokemon;

  SearchHasData(this.pokemon);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
