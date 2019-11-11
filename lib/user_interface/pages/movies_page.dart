import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/models/entities/movie.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/pages/movies_details_page.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

class MoviesPage extends StatefulWidget {
  static const routeName = "/MoviesPage";
  final MoviesBloc moviesBloc;
  MoviesPage({@required this.moviesBloc, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  //MoviesBloc moviesBloc;
  ThemeData _theme;
  Localizer _localizer;
  AppThemeData _appTheme;
  NavigatorState _navigator;
  MediaQueryData _mediaQuery;
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  String message;
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {

      widget.moviesBloc.add(LoadMovies(movies: widget.moviesBloc.state.movies, genreId: widget.moviesBloc.state.genreId));
      setState(() {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.linear, duration: Duration(milliseconds: 500));
        message = "reach the bottom";
        print("reach the bottom");        
      });
    }    
  }

  @override
  void didChangeDependencies() {
    _localizer = Localizer.of(context);
    _theme = Theme.of(context);
    _navigator = Navigator.of(context);
    _mediaQuery = MediaQuery.of(context);
    //moviesBloc = BlocProvider.of<MoviesBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final double statusBarHeight = _mediaQuery.padding.top / 2;
    // final screenHeightPercent = (_mediaQuery.size.height -
    //         _mediaQuery.padding.top -
    //         kBottomNavigationBarHeight) /
    //     100;

    return Container(
      child: BlocBuilder<MoviesBloc, MoviesState>(
          bloc: widget.moviesBloc,
          builder: (BuildContext context, MoviesState state) {
            if (state is Loading) {
              return Loader();
            } else if (state is LoadedMovies) {
              return Container(child: buildColumnWithData(state.movies));
            } else if (state is Initial) {
              widget.moviesBloc.add(LoadMovies());
            }
            return ErrorPage();
          }),
    );
  }

  Widget buildColumnWithData(MovieModel movies) {
    var before = 0.0;
    //_scrollController.jumpTo(before);
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return GridView.builder(
          itemCount: movies.page < movies.total_pages
              ? movies.results.length + 1
              : movies.results.length,
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            //childAspectRatio: _mediaQuery.size.width / (_mediaQuery.size.height / 2), //height of GridView items
          ),
          itemBuilder: (BuildContext context, int index) {
            return (index == movies.results.length)
                ? Container(
                    color: Colors.greenAccent,
                    child: FlatButton(
                      child: Text("Load More"),
                      onPressed: () {
                        //TODO: Provjeriti je li dobar pristup..
                        before = _scrollController.position.maxScrollExtent;
                        widget.moviesBloc.add(LoadMovies(
                            movies: movies,
                            genreId: widget.moviesBloc.state.genreId));
                        // widget.moviesBloc.add(LoadMoreMovies(
                        //     movies: widget.moviesBloc.state.movies));
                      },
                    ),
                  )
                : buildMovieCard(movies, index);
          },
        );
      },
    );
  }

  Container buildMovieCard(MovieModel movies, int index) {
    return Container(
      margin: EdgeInsets.all(2.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
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
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movies.results[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15.0, top: 5.0, bottom: 5.0, right: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    size: 16.0,
                    color: Colors.yellow,
                  ),
                  Text(
                    movies.results[index].vote_average.toString(),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Icon(
                      Icons.people,
                      size: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    movies.results[index].vote_count.toString(),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 3.0),
                  child: Icon(
                    Icons.event_note,
                    size: 16.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  DateFormat("dd.MM.yyyy")
                      .format(tryParse(movies.results[index].release_date)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

DateTime tryParse(String date) {
  if (date == null) return null;
  try {
    return DateTime.parse(date);
  } on FormatException catch (e) {
    print(e.message);
  }
  return null;
}
