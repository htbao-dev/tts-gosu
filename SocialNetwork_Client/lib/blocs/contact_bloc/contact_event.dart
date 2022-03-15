part of 'contact_bloc.dart';

@immutable
abstract class ContactEvent extends Equatable {}

class LoadContactsEvent extends ContactEvent {
  @override
  List<Object> get props => [];
}

class TapContactEvent extends ContactEvent {
  final String contactId;
  TapContactEvent({required this.contactId});
  @override
  List<Object> get props => [contactId];
}
