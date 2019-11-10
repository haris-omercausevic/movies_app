import 'package:meta/meta.dart';
import 'package:movies_app/models/entities/user.dart';

abstract class UsersState {
  final UserModel user;
  UsersState({@required this.user});
}

class Initial extends UsersState {}

class Unauthenticated extends UsersState {}

class Authenticated extends UsersState {
  UserModel user;

  Authenticated({@required this.user}) : assert(user != null);
}

class RegisterSuccess extends UsersState {}

class Error extends UsersState {}

class Loading extends UsersState {}


class LoadedUser extends UsersState {
  LoadedUser({@required UserModel user})
      : assert(user != null),
        super(user: user);
}
