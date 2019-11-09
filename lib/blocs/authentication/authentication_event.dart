import 'package:meta/meta.dart';
import 'package:movies_app/models/requests/authentication_login_body.dart';

abstract class AuthenticationEvent {}

class Authenticate extends AuthenticationEvent {
  final AuthenticationLoginBody body; //request token

  Authenticate({@required this.body}) : assert(body != null);
}

class InitRegister extends AuthenticationEvent {}

class Logout extends AuthenticationEvent {}
