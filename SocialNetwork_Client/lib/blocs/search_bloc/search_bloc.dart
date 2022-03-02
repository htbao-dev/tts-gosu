import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_network_client/exception/token_expired_exception.dart';
import 'package:social_network_client/models/user.dart';
import 'package:social_network_client/repository/user_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  Timer? _debounce;
  UserRepository userRepo;
  SearchBloc({required this.userRepo}) : super(SearchInitial()) {
    on<SearchFieldChangedEvent>((event, emit) async {
      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }
      if (event.query.isNotEmpty) {
        emit(SearchLoadingState());
        _debounce = Timer(const Duration(milliseconds: 500), () async {
          final query = event.query;
          try {
            List<UserWithFriendstatus> users = await userRepo.searchUser(query);
            add(SearchLoadedEvent(users));
          } on RefreshTokenExpiredException catch (_) {
            add(SearchErrorEvent("Token expired"));
          } on Exception catch (e) {
            add(SearchErrorEvent(e.toString()));
          }
        });
      }
    });

    on<SearchLoadedEvent>((event, emit) async {
      // await Future.delayed(const Duration(milliseconds: 500));
      emit(SearchLoaded(event.users));
    });

    on<FriendRequestEvent>(
      (event, emit) {
        emit(FriendRequestSuccessState(event.userId));
      },
    );
  }
}
