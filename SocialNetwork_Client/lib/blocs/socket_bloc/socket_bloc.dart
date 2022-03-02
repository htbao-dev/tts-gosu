import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_network_client/models/message.dart';
import 'package:social_network_client/repository/auth_repository.dart';
import 'package:social_network_client/repository/socket_repository.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  SocketRepository socketRepo;
  AuthRepository authRepo;
  SocketBloc({required this.socketRepo, required this.authRepo})
      : super(SocketInitial()) {
    socketRepo.onRecieveMessage((data) {
      Message message = Message.fromJson(data);
      add(SocketReceiveMessageEvent(message));
    });

    on<SocketReceiveMessageEvent>((event, emit) {
      emit(SocketReceiveMessageState(event.message));
    });

    on<SocketSendMessageEvent>((event, emit) async {
      var msg = {
        "roomId": event.message.roomId!,
        "message": event.message.message!,
        "senderId": event.message.senderId!,
      };
      socketRepo.emitSendMessage(msg);

      emit(SocketSendMessageSuccessState(event.message));
    });
  }
}
