part of 'contact_bloc.dart';

@immutable
abstract class ContactEvent extends Equatable {}

class LoadContactsEvent extends ContactEvent {
  @override
  List<Object> get props => [];
}
