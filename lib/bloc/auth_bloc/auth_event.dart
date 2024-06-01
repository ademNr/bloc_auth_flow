import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;
  const LoggedIn({required this.token});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoggedIn {$token}';
}

class LoggedOut extends AuthEvent {}
