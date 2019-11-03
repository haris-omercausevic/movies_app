import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:movies_app/blocs/users/all.dart';
import 'package:movies_app/repositories/all.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository usersRepository;

  UsersBloc({@required this.usersRepository}) : assert(usersRepository != null);

  @override
  UsersState get initialState => Initial();

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    if (event is LoadCurrentUser) {
      yield* _loadCurrentUser();
    }

    if (event is SetCurrentUserLocation) {
      yield* _setCurrentUserLocation(event);
    }
  }

  Stream<UsersState> _loadCurrentUser() async* {
    yield Loading();

    var user = await usersRepository.getCurrentUser();

    yield LoadedCurrentUser(user: user);
  }

  Stream<UsersState> _setCurrentUserLocation(SetCurrentUserLocation event) async* {
    await usersRepository.setCurrentUserCityId(event.cityId);

    var user = await usersRepository.getCurrentUser();

    yield LoadedCurrentUser(user: user);
  }
}
