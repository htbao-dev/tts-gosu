import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_network_client/repository/friend_repository.dart';

part 'friend_event.dart';
part 'friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepository friendRepo;
  FriendBloc({required this.friendRepo}) : super(const FriendInitial()) {
    on<SendFriendRequestEvent>(
      (event, emit) async {
        int? friendstatus;
        var requestStatus = await friendRepo.sendFriendRequest(event.friendId);
        if (requestStatus.errorCode == null) {
          friendstatus = 0;
          emit(SendFriendRequestSuccessState(event.friendId, friendstatus));
        } else {
          print(requestStatus.message);
          emit(SendFriendRequestErrorState(event.friendId, friendstatus));
        }
      },
    );

    on<CancelFriendRequestEvent>(
      (event, emit) async {
        int? friendstatus;
        var requestStatus =
            await friendRepo.cancelFriendRequest(event.friendId);
        if (requestStatus.errorCode == null) {
          friendstatus = 1;
          emit(CancelFriendRequestSuccessState(event.friendId, friendstatus));
        } else {
          print(requestStatus.message);
          emit(CancelFriendRequestErrorState(event.friendId, friendstatus));
        }
        emit(CancelFriendRequestSuccessState(event.friendId, null));
      },
    );

    on<AcceptFriendRequestEvent>((event, emit) async {
      var requestStatus = await friendRepo.acceptFriendRequest(event.friendId);
      if (requestStatus.errorCode == null) {
        emit(AcceptFriendRequestSuccessState(event.friendId, 2));
      } else {
        print(requestStatus.message);
        emit(AcceptFriendRequestErrorState(
          event.friendId,
          requestStatus.errorCode,
        ));
      }
    });

    on<RejectFriendRequestEvent>((event, emit) async {
      var requestStatus = await friendRepo.rejectFriendRequest(event.friendId);
      if (requestStatus.errorCode == null) {
        emit(RejectFriendRequestSuccessState(event.friendId, null));
      } else {
        print(requestStatus.message);
        emit(RejectFriendRequestErrorState(
          event.friendId,
          requestStatus.errorCode,
        ));
      }
    });
  }
}
