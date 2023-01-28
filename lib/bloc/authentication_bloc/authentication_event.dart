
part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class RegisterUserEvent extends AuthenticationEvent{

  final String email;
  final String password;

  RegisterUserEvent({required this.email,required this.password});

  @override
  // TODO: implement props
  List<Object?> get props =>[email,password];

}

class CompleteProfileEvent extends AuthenticationEvent{

  final String fullName;
  final File? profilePic;

  CompleteProfileEvent({required this.fullName, this.profilePic});

  @override
  // TODO: implement props
  List<Object?> get props => [fullName,profilePic];

}

class LoginUserEvent extends AuthenticationEvent{
  final String email;
  final String password;

  LoginUserEvent({required this.email,required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email,password];
}
