part of 'nav_bloc.dart';

@immutable
abstract class NavState extends Equatable {
  final int index;
  const NavState(this.index);
}

class NavInitial extends NavState {
  const NavInitial() : super(0);
  @override
  List<Object?> get props => [index];
}

class NavSelectState extends NavState {
  final int selectedIndex;
  const NavSelectState(this.selectedIndex) : super(selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}
