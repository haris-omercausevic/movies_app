import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import 'package:movies_app/models/requests/all.dart';
import 'package:movies_app/blocs/authentication/all.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/RegisterPage";

  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ThemeData _theme;
  Localizer _localizer;
  MediaQueryData _mediaQuery;

  String _birthDateString;
  DateTime _birthDate = DateTime.now();

  AuthenticationBloc _authenticationBloc;

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  @override
  void dispose() {
    this._cityController.dispose();
    this._emailController.dispose();
    this._genderController.dispose();
    this._lastNameController.dispose();
    this._usernameController.dispose();
    this._passwordController.dispose();
    this._firstNameController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    _localizer = Localizer.of(context);
    _mediaQuery = MediaQuery.of(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    super.didChangeDependencies();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: _birthDate, firstDate: DateTime(1900), lastDate: DateTime(2101));
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _birthDateString = DateFormat('dd/MM/yyyy').format(_birthDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: _authenticationBloc,
        builder: (BuildContext context, AuthenticationState state) {
          if (state is RegisterSuccess) {
            return Center(
              child: Container(
                child: Text("Successfully registered new account, check your email for verification token"),
              ),
            );
          }

          if (state is Loading) {
            return Loader();
          }

          if (state is Unauthenticated) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: _mediaQuery.size.width / 2.5,
                                child: TextField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(hintText: _localizer.translation.firstName),
                                ),
                              ),
                              Container(
                                width: _mediaQuery.size.width / 2.5,
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(hintText: _localizer.translation.lastName),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: _mediaQuery.size.width / 2.5,
                                child: RaisedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text(_birthDateString ?? _localizer.translation.birthDate),
                                ),
                              ),
                              Container(
                                width: _mediaQuery.size.width / 2.5,
                                child: TextField(
                                  cursorColor: Colors.white,
                                  controller: _genderController,
                                  decoration: InputDecoration(hintText: _localizer.translation.gender),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: _mediaQuery.size.width / 2.5,
                                child: TextField(
                                  controller: _cityController,
                                  decoration: InputDecoration(hintText: _localizer.translation.city),
                                ),
                              ),
                              Container(
                                width: _mediaQuery.size.width / 2.5,
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(hintText: _localizer.translation.email),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(hintText: _localizer.translation.username),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          TextField(
                            cursorColor: Colors.white,
                            controller: _passwordController,
                            decoration: InputDecoration(hintText: _localizer.translation.password),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Container(
                            width: _mediaQuery.size.width,
                            child: RaisedButton(
                              color: _theme.primaryColor,
                              onPressed: () {
                                _authenticationBloc.add(
                                  Register(
                                    body: AuthenticationRegisterBody(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      gender: _genderController.text,
                                      // cityId: int.parse(city.text),
                                      email: _emailController.text,
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      birthDate: DateFormat('dd/MM/yyyy').format(_birthDate),
                                    ),
                                  ),
                                );
                              },
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
                                child: Text(
                                  _localizer.translation.signUp,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ErrorPage();
        },
      ),
    );
  }
}
