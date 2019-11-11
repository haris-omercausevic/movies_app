import 'package:meta/meta.dart';
import 'package:movies_app/models/entities/movie.dart';

abstract class MoviesState {
  final MovieModel movies;
  final int genreId;

  MoviesState({@required this.movies, this.genreId = 0});
}

class Initial extends MoviesState {}

class Error extends MoviesState {}

class Loading extends MoviesState {}

class LoadedMainPage extends MoviesState {}

class LoadedMovies extends MoviesState {
  LoadedMovies({@required MovieModel movies, int genreId = 0})
      : assert(movies != null),
        super(movies: movies, genreId: genreId);
}

// class LoadedMoviesByGenre extends MoviesState {
//   LoadedMoviesByGenre({@required ItemModel movies})
//       : assert(movies != null),
//         super(movies: movies);
// }
