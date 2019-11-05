import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/config/app_settings.dart';
import 'package:movies_app/models/entities/movie.dart';
import 'package:movies_app/models/entities/movie_item.dart';
import 'package:movies_app/repositories/movies_repository.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/pages/movies_details_page.dart';
import 'package:movies_app/utilities/localization/localizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  _SearchAppBarDelegate _searchDelegate;

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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: homeAppBar(),
          body: BlocBuilder<MoviesBloc, MoviesState>(
              bloc: moviesBloc,
              builder: (BuildContext context, MoviesState state) {
                if (state is Loading) {
                  return Loader();
                }
                // else if (state is LoadedMainPage) {
                //   return Center(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         RaisedButton(
                //           onPressed: () => moviesBloc.add(LoadMovies()),
                //           child: Text(
                //             "Load Popular Movies",
                //             style: TextStyle(fontSize: 28),
                //           ),
                //         ),
                //         RaisedButton(
                //           onPressed: () =>
                //               moviesBloc.add(LoadMoviesByGenre(genreId: 35)),
                //           child: Text(
                //             "Load Comedy Movies",
                //             style: TextStyle(fontSize: 28),
                //           ),
                //         ),
                // FutureBuilder<List<GenresModel>>(
                //     future: moviesBloc.moviesRepository.getGenresList(),
                //     builder: (BuildContext context,
                //         AsyncSnapshot<List<GenresModel>> snapshot) {
                //       if (!snapshot.hasData)
                //         return CircularProgressIndicator();
                //       return DropdownButton<GenresModel>(
                //         items: snapshot.data
                //             .map((genre) => DropdownMenuItem<GenresModel>(
                //                   child: Text(genre.name),
                //                   value: genre,
                //                 ))
                //             .toList(),
                //         onChanged: (GenresModel value) {
                //           setState(() {
                //             _currentGenre = value;
                //           });
                //         },
                //         isExpanded: false,
                //         //value: _currentUser,
                //         hint: Text('Select Genre'),
                //       );
                //     }),
                // ],
                // ),
                // );
                // }
                else if (state is LoadedMovies) {
                  _searchDelegate =
                      _SearchAppBarDelegate(state.movies.results);
                  return buildColumnWithData(state.movies);
                  // return Container(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Column(
                  //     children: <Widget>[
                  //       Row(
                  //         children: <Widget>[
                  //           Center(
                  //             child: RaisedButton(
                  //               color: Colors.blue[300],
                  //               onPressed: () => print("Pressed"),
                  //               hoverColor: Colors.green,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Expanded(child: buildColumnWithData(state.movies))
                  //     ],
                  //   ),
                  // );
                  // Text("${fromDate.toLocal()}"),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                  // RaisedButton(
                  //   onPressed: () => _selectDate(context, fromDate),
                  //   child: Text('Select date'),
                  // ),
                  // Text("${toDate.toLocal()}"),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                  // RaisedButton(
                  //   onPressed: () => _selectDate(context, toDate),
                  //   child: Text('Select date'),
                  // ),
                }

                return ErrorPage();
              })),
    );
  }

  // Future<Null> _selectDate(BuildContext context, DateTime date) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: date,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != date) {
  //     setState(() {
  //       date = picked;
  //     });
  //   }
  // }

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
                //"https://image.tmdb.org/t/p/w185${movies.results[index].poster_path}", //ovaj request hendlat negdje drugo
                fit: BoxFit.cover,
              ),
              onTap: () => _onTileClicked(movies.results[index]),
            ),
          ),
        );
      },
    );
  }

  void _onTileClicked(MovieItem movieItem) {
    print("Tile with title: ${movieItem.title} clicked!");
    _navigator.pushNamed(MoviesDetailsPage.routeName, arguments: movieItem);
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
          icon: Icon(Icons.notifications),
          onPressed: () => print("Pressed notif"),
        ),
        IconButton(
          onPressed: () => print("Pressed profile!"),
          icon: Icon(Icons.person),
        ),
      ],
      title: Text(AppSettings.name),
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.directions_bike),
            text: "In theatres",            
          ),
          Tab(
            icon: Icon(Icons.directions_car),
            text: "Popular",            
          ),
          Tab(
            icon: Icon(Icons.shutter_speed),
            text: "Incoming",            
          )
        ],
      ),
    );
  }
}

class _SearchAppBarDelegate extends SearchDelegate<String> {
  final List<MovieItem> _movies;
  //list holds history search words.
  final List<MovieItem> _history;

  //initialize delegate with full word list and history words
  _SearchAppBarDelegate(List<MovieItem> movies)
      : _movies = movies,
        _history = <MovieItem>[],
        //pre-populated history of words
        //_history = <String>['apple', 'orange', 'banana', 'watermelon'],
        super();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Voice input',
              onPressed: () {
                this.query = 'TBW: Get input from voice';
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('===Your Word Choice==='),
            GestureDetector(
              onTap: () {
                //Define your action when clicking on result item.
                //In this example, it simply closes the page
                this.close(context, this.query);
              },
              child: Text(
                this.query,
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<MovieItem> suggestions = this.query.isEmpty
        ? _history
        : _movies.where((word) => word.title.startsWith(query));

    //calling wordsuggestion list
    return _WordSuggestionList(
        query: this.query,
        suggestions: suggestions.toList(),
        onSelected: (MovieItem suggestion) {
          this.query = suggestion.title;
          this._history.insert(0, suggestion);
          showResults(context);
        });
  }
}

class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<MovieItem> suggestions;
  final String query;
  final ValueChanged<MovieItem> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final MovieItem suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.title.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.title.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
