part of 'search_bloc.dart';

abstract class SearchEvent {}

class OnQueryChanged extends SearchEvent {
  String query = '';

  OnQueryChanged(this.query);
}
