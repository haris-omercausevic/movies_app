import 'package:meta/meta.dart';

import 'package:movies_app/models/entities/all.dart';

abstract class UsersState {
  final User user;

  UsersState({@required this.user});
}

class Initial extends UsersState {}

class Error extends UsersState {}

class Loading extends UsersState {}

class LoadedCurrentUser extends UsersState {
  LoadedCurrentUser({@required User user})
      : assert(user != null),
        super(user: user);
}
