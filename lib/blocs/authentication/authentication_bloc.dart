import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:movies_app/repositories/all.dart';
import 'package:movies_app/blocs/authentication/all.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UsersRepository usersRepository;

  AuthenticationBloc({@required this.usersRepository}) : assert(usersRepository != null) {
    this.usersRepository.setUnauthorizedCallback(() => add(Logout()));
  }

  @override
  AuthenticationState get initialState {
    var currentUser = usersRepository.getCurrentUser();

    return currentUser != null ? Authenticated(user: currentUser) : Initial();
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is Authenticate) {
      yield* _authenticateUser(event);
    }

    if (event is AuthenticateWithFacebook) {
      yield* _authenticateWithFacebookUser(event);
    }

    if (event is InitRegister) {
      yield* _initRegister();
    }

    if (event is Register) {
      yield* _register(event);
    }

    if (event is Logout) {
      yield* _logout();
    }
  }

  Stream<AuthenticationState> _authenticateUser(Authenticate event) async* {
    yield Loading();

    final user = await usersRepository.authenticate(event.body);
    yield user != null ? Authenticated(user: user) : Error();
  }

  Stream<AuthenticationState> _authenticateWithFacebookUser(AuthenticateWithFacebook event) async* {
    yield Loading();

    final user = await usersRepository.facebookLogin(event.body);
    yield user != null ? Authenticated(user: user) : Error();
  }

  Stream<AuthenticationState> _initRegister() async* {
    yield Unauthenticated();
  }

  Stream<AuthenticationState> _register(Register event) async* {
    yield Loading();

    yield (await usersRepository.register(event.body)) ? RegisterSuccess() : Error();
  }

  Stream<AuthenticationState> _logout() async* {
    yield Loading();

    await usersRepository.removeCurrentUser();

    yield Unauthenticated();
  }
}
