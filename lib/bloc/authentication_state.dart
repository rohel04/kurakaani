part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class UserRegistrationSuccess extends AuthenticationState{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class UserRegistrationFailed extends AuthenticationState{

  final String message;

  UserRegistrationFailed({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}

class UserLoginSuccess extends AuthenticationState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class UserLoginFailed extends AuthenticationState{

  final String message;

  UserLoginFailed({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}
