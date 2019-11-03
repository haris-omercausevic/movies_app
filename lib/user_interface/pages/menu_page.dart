import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/config/all.dart';
import 'package:movies_app/blocs/users/all.dart';
import 'package:movies_app/blocs/authentication/all.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  ThemeData _theme;
  Localizer _localizer;
  UsersBloc _usersBloc;
  AuthenticationBloc _authenticationBloc;

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    _localizer = Localizer.of(context);
    _usersBloc = BlocProvider.of<UsersBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    _usersBloc.add(LoadCurrentUser());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: this._theme.primaryColor,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerHeader(
                child: BlocBuilder<UsersBloc, UsersState>(
                  builder: (BuildContext context, UsersState state) {
                    if (state is LoadedCurrentUser) {
                      return Container(
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: state.user?.photoPath?.isEmpty ?? false ? Image.network(state.user.photoPath) : Image.asset(Assets.userProfilePlaceholder),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Text(
                              "${state.user.firstName} ${state.user.lastName}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }

                    return Loader();
                  },
                ),
              ),
              Expanded(
                child: Material(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(_localizer.translation.settings),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(_localizer.translation.logout),
                        onTap: () => _authenticationBloc.add(Logout()),
                      ),
                    ],
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
