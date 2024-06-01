import 'package:bloc/bloc.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_event.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_state.dart';
import 'package:bloc_auth/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthUninitialized()) {
    on<AppStarted>(onAppStarted);
    on<LoggedIn>(onLoggedIn);
    on<LoggedOut>(onLoggedOut);
  }

  Future<void> onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final bool hasToken = await authRepository.hasToken();
    if (hasToken) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.persistToken(event.token);
    emit(AuthAuthenticated());
  }

  void onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.deleteToken();
    emit(AuthUnauthenticated());
  }
}
