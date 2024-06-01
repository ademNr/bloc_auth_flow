import 'package:bloc/bloc.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:bloc_auth/bloc/auth_bloc/auth_event.dart';
import 'package:bloc_auth/bloc/login_bloc/login_event.dart';
import 'package:bloc_auth/bloc/login_bloc/login_state.dart';
import 'package:bloc_auth/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  LoginBloc({required this.authRepository, required this.authBloc})
      : super(LoginInitial()) {
    on<LoginButtonPressed>(onLoginButtonPressed);
  }

  Future<void> onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const LoginFailure(error: "Email and password cannot be empty"));
      } else {
        Response response =
            await authRepository.login(event.email, event.password);
        if (response.statusCode == 201) {
          authBloc.add(LoggedIn(token: response.data["token"]));
          emit(LoginInitial());
        } else if (response.statusCode == 400) {
          emit(LoginFailure(error: response.data["message"]));
        } else if (response.statusCode == 500) {
          emit(const LoginFailure(error: "Server Error."));
        } else {
          emit(const LoginFailure(error: "An error occurred during login."));
        }
      }
    } catch (error) {
      emit(const LoginFailure(error: "Error logging in"));
    }
  }
}
