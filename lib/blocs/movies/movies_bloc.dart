import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/models/entities/all.dart';
import 'package:movies_app/repositories/movies_repository.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository moviesRepository;
  MoviesEvent lastEvent;

  MoviesBloc({@required this.moviesRepository})
      : assert(moviesRepository != null);

  @override
  get initialState => Initial();

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    if (event is LoadMainPage) {
      yield LoadedMainPage();
    }
    if (event is LoadMovies) {
      yield* _loadMovies(
          genreId: event.genreId, moviesList: event.movies); // popular
    }

    if (event is LoadMoviesByGenre) {
      yield* _loadMovies(genreId: event.genreId);
      //yield* _loadMoviesByGenre(event.genreId);
    }

//prepravljeno da se ne koristi vec da ide sve u LoadMovies radi ucitavanja novih page-ova iste kategorije
    if (event is LoadMoreMovies) {
      yield* _loadMovies(moviesList: event.movies);
    }
  }

  Stream<MoviesState> _loadMovies(
      {int page = 1, int genreId = 0, MovieModel moviesList = null}) async* {
    
//if event is LoadMore(page=2...)
    if (moviesList != null) {      
      bool moviesAppend =
          moviesList.page < moviesList.total_pages ? true : false;
      var movies = await moviesRepository.getMovies(
          page: moviesList.page + 1, genreId: genreId);
      if (moviesAppend != false) {
        moviesList.page = movies.page;
        moviesList.total_pages = movies.total_pages;
        moviesList.total_results = movies.total_results;
        moviesList.results += movies.results;
      }
      yield movies != null ? LoadedMovies(movies: moviesList, genreId: genreId) : Error();
    }    
     else {
      yield Loading();
      var movies = await moviesRepository.getMovies(genreId: genreId);
      yield movies != null ? LoadedMovies(movies: movies, genreId: genreId) : Error();
    }
  }

  // Future<MovieModel> _loadMoreMovies(
  //     {@required MovieModel moviesList, int genreId = 0}) async {
  //   bool moviesAppend = moviesList.page < moviesList.total_pages ? true : false;
  //   var movies = await moviesRepository.getMovies(
  //       page: moviesList.page + 1, genreId: genreId);
  //   if (moviesAppend != false) {
  //     moviesList.page = movies.page;
  //     moviesList.total_pages = movies.total_pages;
  //     moviesList.total_results = movies.total_results;
  //     moviesList.results += movies.results;
  //   }
  //   return moviesList;
  // }

  // Stream<MoviesState> _loadMovieByid({@required int movieId}) async* {
  //   yield Loading();
  //   var movies = await moviesRepository.getMovieById(movieId: movieId);
  //   yield movies != null ? LoadedMovies(movies: movies) : Error();
  // }

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
