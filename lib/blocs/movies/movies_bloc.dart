import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/models/entities/all.dart';
import 'package:movies_app/repositories/movies_repository.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository moviesRepository;

  MoviesBloc({@required this.moviesRepository})
      : assert(moviesRepository != null);

  @override
  // DONE: implement initialState
  get initialState => Initial();

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    // DONE: implement mapEventToState

    if (event is LoadMainPage) {
      yield* _loadMainPage();
    }
    if (event is LoadMovies) {
      // popular, trending
      yield* _loadMovies();
    }

    if (event is LoadMoreMovies) {
      yield* _loadMoreMovies(moviesList: event.movies);
    }

    if (event is LoadMoviesByGenre) {
      // genre
      yield* _loadMovies(genreId: event.genreId);
      //yield* _loadMoviesByGenre(event.genreId);
    }

    // if (event is LoadTopRatingMovies) {
    //   // top raitng
    //   yield* _loadMovies();
    // }

    // if (event is LoadUpcomingMovies) {
    //   //upcoming
    //   yield* _loadMovies();
    // }

    // if(event is LoadMoviesGenre){
    //   yield* _loadMoviesGenre();
    // }
  }

  Stream<MoviesState> _loadMainPage() async* {
    //yield Loading();
    yield LoadedMainPage();
  }

  Stream<MoviesState> _loadMovies({int genreId = 0}) async* {
    yield Loading();
    var movies = await moviesRepository.getMovies(genreId: genreId);
    yield movies != null ? LoadedMovies(movies: movies) : Error();
  }

  Stream<MoviesState> _loadMoreMovies({@required MovieModel moviesList}) async* {
    yield Loading();
    var moviesAppend = moviesList.page < moviesList.total_pages
        ? await moviesRepository.getMovies(page: moviesList.page + 1)
        : null;

    if (moviesAppend != null) {
      moviesList.page = moviesAppend.page;
      moviesList.total_pages = moviesAppend.total_pages;
      moviesList.total_results = moviesAppend.total_results;
      moviesList.results += moviesAppend.results;
      yield LoadedMovies(movies: moviesList);
    } else {
      yield Error();
    }
  }

  // Stream<MoviesState> _loadMoviesByGenre(int genreId) async* {
  //   yield Loading();
  //   var movies = await moviesRepository.getMovies(genreId: genreId);
  //   yield movies != null? LoadedMovies(movies: movies): Error();
  // }

  // Stream<MoviesState> _loadGenres() async* {
  //   yield Loading();
  //   var genres = await moviesRepository.getGenres();
  //   yield genres != null? LoadedGenres(): Error();
  // }

//  Stream<MoviesState> _loadMoviesGenre({int genreId = 0}) async* {
//     yield Loading();
//     var genres = await moviesRepository.getGenres();
//     var movies = await moviesRepository.getMovies(genreId: genreId);
//     yield movies != null? LoadedMoviesGenres(movies: movies): Error();
//   }

}
