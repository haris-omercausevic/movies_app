import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:movies_app/blocs/search/search_event.dart';
import 'package:movies_app/blocs/search/search_state.dart';
import 'package:movies_app/models/all.dart';
import 'package:movies_app/repositories/all.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MoviesRepository moviesRepository;

  SearchBloc({@required this.moviesRepository})
      : assert(moviesRepository != null);

  @override
  SearchState get initialState => Initial();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    // DONE: implement mapEventToState
    if (event is LoadSearch) {
      yield* _loadSearch(query: event.query);
    }
    if (event is LoadHistory) {
      yield* _loadSearch();
    }

    if (event is SetHistory) {
      await moviesRepository.setSearchHistory(event.history);
    }
  }

  Stream<SearchState> _loadSearch({String query = ""}) async* {
    yield Loading();

    if (query.isEmpty || query == null) {
      var history = await moviesRepository.getSearchHistory();
      yield history != null
          ? LoadedSearch(movies: MovieModel(results: history, page: 1))
          : Error();
    } else {
      var movies = await moviesRepository.getMoviesSearch(query: query);
      yield movies != null ? LoadedSearch(movies: movies) : Error();
    }
  }
}
