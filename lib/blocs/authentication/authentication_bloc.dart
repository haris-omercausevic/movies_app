import 'package:meta/meta.dart';
import 'package:movies_app/blocs/authentication/authentication_event.dart';
import 'package:movies_app/blocs/authentication/authentication_state.dart';
import 'package:movies_app/repositories/users_repository.dart';
import 'package:bloc/bloc.dart';


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
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) {
    // TODO: implement mapEventToState
    return null;
  }
}