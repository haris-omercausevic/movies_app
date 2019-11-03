import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/genres/genres_bloc.dart';
import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/user_interface/common/app_theme.dart';
import 'package:movies_app/user_interface/pages/movies_page.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/";

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  ThemeData _theme;
  Localizer _localizer;
  AppThemeData _appTheme;
  NavigatorState _navigator;
  MediaQuery _mediaQuery;
  GenresBloc _genresBloc;
  MoviesBloc _moviesBloc;

  @override
  void didChangeDependencies() {
    _localizer = Localizer.of(context);
    _theme = Theme.of(context);

    _moviesBloc = BlocProvider.of<MoviesBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _theme.backgroundColor,
      height: double.infinity,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _moviesBloc.add(LoadMovies());
                Navigator.of(context).pushNamed(MoviesPage.routeName);
              },
              child: Text(
                _localizer.translation.loadPopularMovies,
                style: TextStyle(fontSize: 28),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _moviesBloc.add(LoadMoviesByGenre(genreId: 35));
                Navigator.of(context).pushNamed(MoviesPage.routeName);
              },
              child: Text(
                _localizer.translation.loadComedyMovies,
                style: TextStyle(fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
