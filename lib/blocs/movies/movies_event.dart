import 'package:flutter/material.dart';

abstract class MoviesEvent {}

class LoadMovies extends MoviesEvent {}

class LoadMoviesByGenre extends MoviesEvent {
  final int genreId;
  LoadMoviesByGenre({@required this.genreId}) : assert(genreId != null);
}

class LoadMoreMovies extends MoviesEvent {}

class LoadTopRatingMovies extends MoviesEvent {}

class LoadUpcomingMovies extends MoviesEvent {}

class LoadMainPage extends MoviesEvent {}

class SaveToWishlist extends MoviesEvent {
  final int movieId;

  SaveToWishlist({@required this.movieId}) : assert(movieId != null);
}
