part of 'nav_bloc.dart';

@immutable
abstract class NavEvent extends Equatable {}

class NavSelectEvent extends NavEvent {
  final int index;
  NavSelectEvent(this.index);
  @override
  List<Object> get props => [index];
}
