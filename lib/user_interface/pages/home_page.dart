import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/config/all.dart';
import 'package:movies_app/user_interface/pages/all.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/common/app_theme.dart';
import 'package:movies_app/blocs/users/all.dart' as package_users_bloc;

class HomePage extends StatefulWidget {
  static const routeName = "/";

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;
  ThemeData _theme;
  AppThemeData _appTheme;
  MediaQueryData _mediaQuery;
  package_users_bloc.UsersBloc _usersBloc;

  static List<Widget> widgetOptions = <Widget>[
    Container(),
    Container(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
    } else if (index == 3) {
      scaffoldKey.currentState.openDrawer();
    } else if (index == 4) {
      scaffoldKey.currentState.openEndDrawer();
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    _appTheme = AppTheme.of(context);
    _mediaQuery = MediaQuery.of(context);

    _usersBloc = BlocProvider.of<package_users_bloc.UsersBloc>(context);
    _usersBloc.add(package_users_bloc.LoadCurrentUser());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = _mediaQuery.padding.top / 2;
    final screenHeightPercent = (_mediaQuery.size.height - _mediaQuery.padding.top - kBottomNavigationBarHeight) / 100;

    return Scaffold(
      key: scaffoldKey,
      drawer: Menu(),
      endDrawer: SizedBox(
        width: _mediaQuery.size.width,
        child: Drawer(
          elevation: 10,
          child: Container(),
        ),
      ),
      body: Container(
        color: _theme.backgroundColor,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(statusBarHeight)),
            Container(
              color: _theme.backgroundColor,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              height: screenHeightPercent * 13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppSettings.name,
                    style: TextStyle(
                      color: _appTheme.primaryTextColor,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.map,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: _theme.backgroundColor,
              height: screenHeightPercent * 87,
              child: widgetOptions[selectedIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 8,
        unselectedFontSize: 8,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(AppIcons.homePageFacilities),
            title: Text("Facilities"),
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.homePageEvents),
            title: Text("Events"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.donut_small,
              color: Colors.black,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.homePageUserProfile),
            title: Text("Me"),
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.homePageMessages),
            title: Text("Messages"),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(Assets.logo),
        ),
        elevation: 2.0,
      ),
    );
  }
}
