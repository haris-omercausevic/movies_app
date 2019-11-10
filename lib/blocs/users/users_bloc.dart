import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:movies_app/blocs/users/users_event.dart';
import 'package:movies_app/blocs/users/users_state.dart';
import 'package:movies_app/repositories/users_repository.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository usersRepository;

  UsersBloc({@required this.usersRepository}) : assert(usersRepository != null);

  @override
  // DONE: implement initialState
  get initialState => Initial();

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    // DONE: implement mapEventToState
    if (event is LoadUser) {
      yield* _loadUser();
    }
  }

  Stream<UsersState> _loadUser() async* {
    yield Loading();
    var user = await usersRepository.getCurrentUser();
    yield LoadedUser(user: user);
  }
}
