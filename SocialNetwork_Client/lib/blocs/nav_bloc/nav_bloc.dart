import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavInitial()) {
    on<NavSelectEvent>((event, emit) {
      emit(NavSelectState(event.index));
    });
  }
}
