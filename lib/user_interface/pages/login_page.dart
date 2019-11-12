//page za login auth i webview
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/authentication/authentication_bloc.dart';
import 'package:movies_app/blocs/authentication/authentication_event.dart';
import 'package:movies_app/blocs/authentication/authentication_state.dart';
import 'package:movies_app/models/requests/authentication_login_body.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

//NE KORISTI SE
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Localizer localizer;
  MediaQueryData mediaQuery;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    localizer = Localizer.of(context);
    mediaQuery = MediaQuery.of(context);

    super.didChangeDependencies();
  }

  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final localizer = Localizer.of(context);

    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: authenticationBloc,
        builder: (context, state) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 150, 20, 0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(hintText: localizer.translation.username),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        TextField(
                          cursorColor: Colors.white,
                          controller: passwordController,
                          decoration: InputDecoration(hintText: localizer.translation.password),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Padding(padding: EdgeInsets.all(10)),
                        Container(
                          width: mediaQuery.size.width,
                          child: RaisedButton(
                            color: theme.primaryColor,
                            onPressed: () {
                              authenticationBloc.add(
                                Authenticate(
                                  body: AuthenticationLoginBody(
                                    username: usernameController.text,
                                    password: passwordController.text,
                                  ),
                                ),
                              );
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
                              child: Text(
                                localizer.translation.signIn,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(20)),
                        Container(
                          width: mediaQuery.size.width,
                          child: RaisedButton(
                            onPressed: () {
                              authenticationBloc.add(InitRegister());
                              //Navigator.of(context).pushNamed(RegisterPage.routeName);
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
                              child: Text(
                                localizer.translation.signUp,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
