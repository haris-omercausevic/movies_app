import 'package:flutter/material.dart';
import 'package:movies_app/models/entities/all.dart';

abstract class MoviesEvent {
}

class LoadMovies extends MoviesEvent {
  final int page;
  LoadMovies({this.page = 1});
}

class LoadMoviesByGenre extends MoviesEvent {
  final int genreId;
  LoadMoviesByGenre({@required this.genreId}): assert(genreId != null);
}

class LoadMoreMovies extends MoviesEvent {
   final MovieModel movies;
  LoadMoreMovies({@required this.movies});
}

class LoadTopRatingMovies extends MoviesEvent {}

class LoadUpcomingMovies extends MoviesEvent {}

class LoadMainPage extends MoviesEvent {}

class SaveToWishlist extends MoviesEvent {
  final int movieId;

  SaveToWishlist({@required this.movieId}) : assert(movieId != null);
}
