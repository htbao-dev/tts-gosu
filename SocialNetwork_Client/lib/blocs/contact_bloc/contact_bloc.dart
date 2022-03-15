import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_client/blocs/room_bloc/room_bloc.dart';
import 'package:social_network_client/models/room.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/repository/room_repository.dart';
import 'package:social_network_client/repository/user_repository.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final UserRepository userRepo;
  final RoomRepository roomRepo;
  final RoomBloc roomBloc;
  ContactBloc(
      {required this.userRepo, required this.roomBloc, required this.roomRepo})
      : super(ContactInitial()) {
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

    on<TapContactEvent>(
      (event, emit) async {
        Room room = await roomRepo.getInboxRoom(event.contactId);
        roomBloc.add(JoinRoomEvent(room));
      },
    );
  }
}
