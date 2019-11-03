import 'package:meta/meta.dart';

import 'package:movies_app/models/requests/all.dart';

abstract class AuthenticationEvent {}

class Authenticate extends AuthenticationEvent {
  final AuthenticationLoginBody body;

  Authenticate({@required this.body}) : assert(body != null);
}

class AuthenticateWithFacebook extends AuthenticationEvent {
  final AuthenticationFacebookLoginBody body;

  AuthenticateWithFacebook({@required this.body}) : assert(body != null);
}

class Register extends AuthenticationEvent {
  final AuthenticationRegisterBody body;

  Register({@required this.body}) : assert(body != null);
}

class InitRegister extends AuthenticationEvent {}

class Logout extends AuthenticationEvent {}
