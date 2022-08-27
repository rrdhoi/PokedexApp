import 'package:bloc/bloc.dart';

part 'scroll_event.dart';

class ScrollBloc extends Bloc<ScrollEvent, bool> {
  ScrollBloc() : super(false) {
    on<ScrollMaxBottom>((event, emit) => emit(true));
    on<ScrollUp>((event, emit) => emit(false));
  }
}
