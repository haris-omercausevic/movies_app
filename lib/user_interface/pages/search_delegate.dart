import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/search/all.dart';

import 'package:movies_app/models/entities/movie_item.dart';
import 'package:movies_app/user_interface/common/error_page.dart';
import 'package:movies_app/user_interface/common/loader.dart';

class SearchAppBarDelegate extends SearchDelegate<String> {
  //list holds history search words.
  //final MoviesBloc moviesBloc;
  final SearchBloc searchBloc;
  List<MovieItem> _history = [];

  //initialize delegate with full word list and history words
  SearchAppBarDelegate({@required this.searchBloc})
      : assert(searchBloc != null),
        super()
  // : _history =  json.decode(moviesBloc.moviesRepository.storageRepository
  //       .getString(_searchHistoryListKey)) as List<MovieItem>,
  //DONE: load from storageRepository -> sharedPrefs..
  {
    //Load history from storage repository
    //ILI
    //_history = searchBloc.moviesRepository.getSearchHistory();
    _history = searchBloc.moviesRepository.getSearchHistory();
  }

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
                this.query = 'Not yet implemented.';
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
    searchBloc.add(LoadSearch(query: query));
    //calling wordsuggestion list
    return Container(
      child: BlocBuilder<SearchBloc, SearchState>(
          bloc: searchBloc,
          builder: (BuildContext context, SearchState state) {
            if (state is Loading) {
              return Loader();
            } else if (state is LoadedSearch) {
              return _WordSuggestionList(
                  query: this.query,
                  suggestions: state.movies.results,
                  onSelected: (MovieItem suggestion) {
                    this.query = suggestion.title;

                    //_history remove existing item and add it back on top
                    _history.isEmpty
                        ? null
                        : this
                            ._history
                            .removeWhere((item) => item.id == suggestion.id);
                    this._history.insert(0, suggestion);
                    searchBloc.add(SetHistory(_history));
                    // searchBloc.moviesRepository.storageRepository.setString(
                    //     Keys.searchHistoryListKey, json.encode(_history));
                    showResults(context);
                  });
            }
            return ErrorPage();
          }),
    );
  }
}

//TODO: https://github.com/SAGARSURI/PixelPerfect
//pregledati malo ovaj search
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
          leading: Tab(
            icon: Container(
              child: Image.network(
                suggestion.poster_path,
                fit: BoxFit.cover,
              ),
              height: 100,
              width: 100,
            ),
          ),
          // Highlight the substring that matched the query.
          title: Text(
            suggestion.title,
            style: textTheme,
          ),
          subtitle:
              //Text(suggestion == null? "": DateTime.parse(suggestion.release_date).year.toString()),
              Text(tryParse(suggestion.release_date)),                
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}

String tryParse(String date){
  if(date == null) return "";
  try{
    return DateTime.parse(date).year.toString();
  }
  on FormatException catch (e){
    print(e.message);    
  }
return "";
}