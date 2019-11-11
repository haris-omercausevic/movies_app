import 'package:flutter/material.dart';
import 'package:movies_app/models/entities/all.dart';

abstract class MoviesEvent {  
  final int genreId;
  final MovieModel movies;
  MoviesEvent({this.movies = null, this.genreId = 0});  
}

class LoadMovies extends MoviesEvent { 
  LoadMovies({MovieModel movies = null, int genreId = 0}): super(movies:movies, genreId: genreId);
}


//posto je kod prepravljen na LoadMovies radi ucitavanja page-ova, nece se pozivati
class LoadMoviesByGenre extends MoviesEvent {
  final int genreId;  
  LoadMoviesByGenre({@required this.genreId}):assert(genreId != null), super();
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
