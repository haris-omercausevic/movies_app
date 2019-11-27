import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/blocs/search/all.dart';
import 'package:movies_app/blocs/users/users_bloc.dart';
import 'package:movies_app/blocs/users/users_event.dart';
import 'package:movies_app/config/app_settings.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/pages/all.dart';
import 'package:movies_app/user_interface/pages/search_delegate.dart';
import 'package:movies_app/user_interface/pages/users_page.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

import 'package:speech_recognition/speech_recognition.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/";

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeData _theme;
  Localizer _localizer;
  AppThemeData _appTheme;
  NavigatorState _navigator;
  MediaQueryData _mediaQuery;

  MoviesBloc _moviesBloc;
  SearchBloc _searchBloc;
  UsersBloc _usersBloc;
  SearchAppBarDelegate _searchDelegate;
  SpeechRecognition _speech = SpeechRecognition();

  int selectedIndex = 0;
  //List<Widget> _children;

  
  @override
  void initState() {
    _moviesBloc = BlocProvider.of<MoviesBloc>(context);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _usersBloc = BlocProvider.of<UsersBloc>(context);
    _searchDelegate = SearchAppBarDelegate(searchBloc: _searchBloc);

    // _children = [
    //   MoviesPage(
    //     moviesBloc: _moviesBloc,
    //   ),
    //   MoviesPage(
    //     moviesBloc: _moviesBloc,
    //   ),
    //   MoviesPage(
    //     moviesBloc: _moviesBloc,
    //   ),
    // ];

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizer = Localizer.of(context);
    _theme = Theme.of(context);
    _navigator = Navigator.of(context);
    _mediaQuery = MediaQuery.of(context);
    _moviesBloc = BlocProvider.of<MoviesBloc>(context);
    _searchBloc = BlocProvider.of<SearchBloc>(context);    
    super.didChangeDependencies();
  }


//Prepraviti da se ne poziva uvijek metoda, api itd, vec samo kada refreshuje, a do tad da se ucitava iz storageRepo ili tako nesto
  void _onTabTapped(int index) {
    if (index == 0) {
      _moviesBloc.add(LoadMovies());
    } else if (index == 1) {
      _moviesBloc
          .add(LoadMovies(movies: _moviesBloc.state.movies)); // load page 2
    } else if (index == 2) {
      _moviesBloc.add(LoadMoviesByGenre(genreId: 35));
      //_searchDelegate = _SearchAppBarDelegate(_moviesBloc.state.movies.results);
    }
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final double statusBarHeight = _mediaQuery.padding.top / 2;
    // final screenHeightPercent = (_mediaQuery.size.height -
    //         _mediaQuery.padding.top -
    //         kBottomNavigationBarHeight) /
    //     100;

    return Scaffold(
      appBar: homeAppBar(),
      body: Dismissible(
        resizeDuration: null,
        child: MoviesPage(
          moviesBloc: _moviesBloc,
        ),
        key: ValueKey(selectedIndex),
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart && selectedIndex < 2) {
            selectedIndex++;
            _onTabTapped(selectedIndex);
          } else if (direction == DismissDirection.startToEnd &&
              selectedIndex > 0) {
            selectedIndex--;
            _onTabTapped(selectedIndex);
          }
        },
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.endToStart && selectedIndex < 2) {
            return true;
          } else if (direction == DismissDirection.startToEnd &&
              selectedIndex > 0) {
            return true;
          }
          return false;
        },
        //movementDuration: Duration(milliseconds: 300),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget homeAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: _searchDelegate);
          },
        ),
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () => print("Pressed favorites"),
        ),
        IconButton(
          onPressed: () {
            _usersBloc.add(LoadUser());
            _navigator.pushNamed(UsersDetailsPage.routeName, arguments: _usersBloc);
          },
          icon: Icon(Icons.person),
        ),
      ],
      title: Text(AppSettings.name),
    );
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      selectedFontSize: 8,
      unselectedFontSize: 8,
      onTap: _onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(_localizer.translation.popular),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rss_feed),
          title: Text('In theatres'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.new_releases),
          title: Text('Upcoming'),
        ),
      ],
    );
  }
}
