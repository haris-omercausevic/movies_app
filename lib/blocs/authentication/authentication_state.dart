import 'package:meta/meta.dart';

import 'package:movies_app/models/entities/all.dart';

abstract class AuthenticationState {}

class Initial extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  User user;

  Authenticated({@required this.user}) : assert(user != null);
}

class RegisterSuccess extends AuthenticationState {}

class Error extends AuthenticationState {}

class Loading extends AuthenticationState {}
