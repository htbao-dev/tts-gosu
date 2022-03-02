import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_network_client/exception/token_expired_exception.dart';
import 'package:social_network_client/models/room.dart';
import 'package:social_network_client/repository/room_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository roomRepo;
  RoomBloc({required this.roomRepo}) : super(RoomInitial()) {
    on<GetListRoomEvent>(
      (event, emit) async {
        emit(GetListRoomLoading());
        try {
          List<Room> listRoom = await roomRepo.getListRoom("");
          emit(GetListRoomLoaded(listRoom: listRoom));
        } on RefreshTokenExpiredException catch (e) {
          // ignore: avoid_print
          print(e.message);
          // emit(HomeGetFriendsError(e.message));
        } catch (e) {
          // ignore: avoid_print
          print(e);
          // emit(HomeGetFriendsError(e.toString()));
        }
      },
    );

    on<JoinRoomEvent>((event, emit) {
      emit(JoinRoomState(room: event.room));
    });
  }
}
