import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/models/entities/movie.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/pages/movies_details_page.dart';
import 'package:movies_app/utilities/localization/localizer.dart';



class MoviesPage extends StatefulWidget {
  MoviesPage({Key key}) : super(key: key);
  static const routeName = "/MoviesPage";

  @override
  State<StatefulWidget> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  MoviesBloc moviesBloc;
  ThemeData _theme;
  Localizer _localizer;
  AppThemeData _appTheme;
  NavigatorState _navigator;
  MediaQueryData _mediaQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizer = Localizer.of(context);
    _theme = Theme.of(context);
    _navigator = Navigator.of(context);
    _mediaQuery = MediaQuery.of(context);
    moviesBloc = BlocProvider.of<MoviesBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // DONE: implement build

    return Container(
            child: BlocBuilder<MoviesBloc, MoviesState>(
                bloc: moviesBloc,
                builder: (BuildContext context, MoviesState state) {
                  if (state is Loading) {
                    return Loader();
                  }
                  else if (state is LoadedMovies) {
                    return buildColumnWithData(state.movies);
                  }
                  else if(state is Initial)
                  {
                    moviesBloc.add(LoadMovies());
                  }
                  return ErrorPage();
                }),
          );
  }

   Widget buildColumnWithData(MovieModel movies) {
    return GridView.builder(
      itemCount: movies.results.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: GridTile(
            footer: Text(
              movies.results[index].title,
              style: TextStyle(color: Colors.white),
            ),
            child: InkResponse(
              enableFeedback: true,
              child: Image.network(
                movies.results[index].poster_path,
                fit: BoxFit.cover,
              ),
              onTap: () => _navigator.pushNamed(MoviesDetailsPage.routeName,
                  arguments: movies.results[index]),
            ),
          ),
        );
      },
    );
  }

}