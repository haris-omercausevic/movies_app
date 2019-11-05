import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/config/app_settings.dart';
import 'package:movies_app/models/entities/movie.dart';
import 'package:movies_app/models/entities/movie_item.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/pages/all.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

import 'movies_details_page.dart';

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
  _SearchAppBarDelegate _searchDelegate;

  List<Widget> _children = [
    MoviesPage(),
    MoviesPage(),
    MoviesPage(),
  ];
  void _onTabTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
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
    final double statusBarHeight = _mediaQuery.padding.top / 2;
    final screenHeightPercent = (_mediaQuery.size.height -
            _mediaQuery.padding.top -
            kBottomNavigationBarHeight) /
        100;

    return Scaffold(
      appBar: homeAppBar(),
      bottomNavigationBar: bottomNavBar(),
      body: _children[selectedIndex]
      
      //  BlocBuilder<MoviesBloc, MoviesState>(
      //     bloc: _moviesBloc,
      //     builder: (BuildContext context, MoviesState state) {
      //       if (state is Loading) {
      //         return Loader();
      //       } else if (state is LoadedMovies) {
      //         _searchDelegate = _SearchAppBarDelegate(state.movies.results);
      //         return buildColumnWithData(state.movies);
      //       } else if (state is Initial) {
      //         _moviesBloc.add(LoadMovies());
      //       }

      //       return ErrorPage();
      //     })
          ,
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
          title: Text('Popular'),
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
      // bottom: TabBar(
      //   tabs: <Widget>[
      //     Tab(
      //       icon: Icon(Icons.directions_bike),
      //       text: "In theatres",
      //     ),
      //     Tab(
      //       icon: Icon(Icons.directions_car),
      //       text: "Popular",
      //     ),
      //     Tab(
      //       icon: Icon(Icons.shutter_speed),
      //       text: "Upcoming",
      //     )
      //   ],
      // ),
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
