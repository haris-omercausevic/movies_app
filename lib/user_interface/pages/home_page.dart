import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/genres/genres_bloc.dart';
import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/config/app_settings.dart';
import 'package:movies_app/models/entities/movie_item.dart';
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
  MediaQueryData _mediaQuery;

  MoviesBloc _moviesBloc;

  //GenresBloc _genresBloc;
  

  _SearchAppBarDelegate _searchDelegate;

  @override
  void initState() {
    _searchDelegate = _SearchAppBarDelegate(null);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizer = Localizer.of(context);
    _theme = Theme.of(context);
    _navigator = Navigator.of(context);
    _mediaQuery = MediaQuery.of(context);

    _moviesBloc = BlocProvider.of<MoviesBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: homeAppBar(),
        body: Container(
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
                    _navigator.pushNamed(MoviesPage.routeName);
                  },
                  child: Text(
                    _localizer.translation.loadPopularMovies,
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _moviesBloc.add(LoadMoviesByGenre(genreId: 35));
                    _navigator.pushNamed(MoviesPage.routeName);
                  },
                  child: Text(
                    _localizer.translation.loadComedyMovies,
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
            //child: Text("In theatres"),
          ),
          Tab(
            icon: Icon(Icons.directions_car),
            text: "Popular",
            //child: Text("Popular"),
          ),
          Tab(
            icon: Icon(Icons.shutter_speed),
            text: "Incoming",
            //child: Text("Incoming"),
          )
        ],
      ),
    );
  }
}

class _SearchAppBarDelegate extends SearchDelegate<String> {
  final List<MovieItem> _movies;
  //list holds history search words.
  final List<String> _history;

  //initialize delegate with full word list and history words
  _SearchAppBarDelegate(List<MovieItem> movies)
      : _movies = movies,
        _history = <String>[],
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
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _movies.where((word) => word.title.startsWith(query));

    //calling wordsuggestion list
    return _WordSuggestionList(
        query: this.query,
        suggestions: suggestions.toList(),
        onSelected: (String suggestion) {
          this.query = suggestion;
          this._history.insert(0, suggestion);
          showResults(context);
        });
  }
}

class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
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
