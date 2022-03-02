part of 'contact_bloc.dart';

@immutable
abstract class ContactState extends Equatable {}

class ContactInitial extends ContactState {
  @override
  List<Object> get props => [];
}
