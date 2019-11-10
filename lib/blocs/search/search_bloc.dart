import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:movies_app/blocs/search/search_event.dart';
import 'package:movies_app/blocs/search/search_state.dart';
import 'package:movies_app/repositories/all.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MoviesRepository moviesRepository;

  SearchBloc({@required this.moviesRepository})
      : assert(moviesRepository != null);

  @override
  // DONE: implement initialState
  get initialState => Initial();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    // DONE: implement mapEventToState
    if(event is LoadSearch){
      yield* _loadSearch();
    }
  }

Stream<SearchState> _loadSearch() async* {
    yield Loading();
    var movies = await moviesRepository.getMoviesSearch();
    yield LoadedSearch(movies: movies);
  }

}
