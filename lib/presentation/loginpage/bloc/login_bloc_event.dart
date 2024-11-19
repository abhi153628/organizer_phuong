import 'package:equatable/equatable.dart';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithEmailPassword extends LoginEvent {
  final String email;
  final String password;

  const LoginWithEmailPassword(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogle extends LoginEvent {}
