import 'package:meta/meta.dart';
import 'package:movies_app/models/entities/movie.dart';

abstract class MoviesState {
  final MovieModel movies;

  MoviesState({@required this.movies});
}

class Initial extends MoviesState {}

class Error extends MoviesState {}

class Loading extends MoviesState {}

class LoadedMainPage extends MoviesState {}

class LoadedMovies extends MoviesState {
  LoadedMovies({@required MovieModel movies})
      : assert(movies != null),
        super(movies: movies);
}

// class LoadedMoviesByGenre extends MoviesState {
//   LoadedMoviesByGenre({@required ItemModel movies})
//       : assert(movies != null),
//         super(movies: movies);
// }
