import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/repository/user_repository.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final UserRepository userRepo;
  ContactBloc({required this.userRepo}) : super(ContactInitial()) {
    on<LoadContactsEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      try {
        var listFriend = await userRepo.getListFriend();
        emit(ContactLoadedState(listFriend, userId!));
      } catch (_) {
        emit(ContactErrorState());
      }
    });
  }
}
