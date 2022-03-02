import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_network_client/repository/auth_repository.dart';
import 'package:social_network_client/repository/socket_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  final SocketRepository socketRepo;
  AuthBloc({required this.authRepo, required this.socketRepo})
      : super(LoginInitialState()) {
    on<LoginUsernameChangedEvent>((event, emit) {
      // print(event.username);
      emit(LoginUsernameChangedState(username: event.username));
    });

    on<LoginPasswordChangedEvent>((event, emit) =>
        emit(LoginPasswordChangedState(password: event.password)));

    on<LoginSubmitEvent>((event, emit) async {
      emit(LoginLoadingState());
      LoginStatus status = await authRepo.login(event.username, event.password);
      await Future.delayed(const Duration(seconds: 1));
      switch (status) {
        case LoginStatus.loginSuccess:
          _doWhenLoginSuccess();
          emit(LoginSuccessState());
          break;
        case LoginStatus.passwordIncorrect:
          emit(LoginFailureState(error: 'Mật khẩu không đúng'));
          break;
        case LoginStatus.userNotFound:
          emit(LoginFailureState(error: 'Tài khoản không tồn tại'));
          break;
        case LoginStatus.tokenNotFound:
        case LoginStatus.unknownError:
          emit(LoginFailureState(error: 'Đăng nhập thất bại'));
          break;
      }
    });

    on<CheckLoginEvent>((event, emit) async {
      try {
        bool isOK = await authRepo.refreshAccessToken();
        if (isOK) {
          _doWhenLoginSuccess();
          emit(LoginSuccessState());
        } else {
          emit(ShowLoginPageState());
        }
      } catch (e) {
        emit(ShowLoginPageState());
      }
    });

    on<LogoutEvent>((event, emit) async {
      // emit(LogoutLoadingState());
      await authRepo.logout();
      socketRepo.disconnect();
      emit(LogoutState());
    });

    on<ShowRegisterPageEvent>((event, emit) => emit(ShowRegisterPageState()));
    on<ShowLoginPageEvent>((event, emit) => emit(ShowLoginPageState()));
    on<RegisterSubmitEvent>(((event, emit) async {
      emit(RegisterLoadingState());
      RegisterStatus status =
          await authRepo.register(event.username, event.password, event.name);
      switch (status) {
        case RegisterStatus.registerSuccess:
          emit(RegisterSuccessState());
          break;
        case RegisterStatus.userAlreadyExists:
          emit(RegisterFailureState(error: 'Tên đăng nhập đã tồn tại'));
          break;
        case RegisterStatus.unknownError:
          emit(RegisterFailureState(error: 'Đăng ký thất bại'));
          break;
      }
    }));
  }

  void _doWhenLoginSuccess() {
    socketRepo.connect();
    // String? userId = await authRepo.getLocalData(LocalData.userId);
    // String? accessToken = await authRepo.getLocalData(LocalData.accessToken);
    // var test = await socketRepo.init(accessToken!, userId!);
    // print(test);
  }
}
