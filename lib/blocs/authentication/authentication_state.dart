import 'package:meta/meta.dart';
import 'package:movies_app/models/entities/user.dart';

abstract class AuthenticationState {}

class Initial extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  UserModel user;

  Authenticated({@required this.user}) : assert(user != null);
}

class RegisterSuccess extends AuthenticationState {}

class Error extends AuthenticationState {}

class Loading extends AuthenticationState {}
