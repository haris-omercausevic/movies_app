
import 'package:meta/meta.dart';
import 'package:movies_app/models/entities/movie.dart';

abstract class SearchState {
  final MovieModel movies;

  SearchState({@required this.movies});
}

class Initial extends SearchState {}

class Error extends SearchState {}

class Loading extends SearchState {}

class LoadedSearch extends SearchState {
   LoadedSearch({@required MovieModel movies})
      : assert(movies != null),
        super(movies: movies);
}