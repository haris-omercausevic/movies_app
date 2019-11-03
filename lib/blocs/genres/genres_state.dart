import 'package:flutter/widgets.dart';
import 'package:movies_app/models/entities/genre.dart';

abstract class GenresState {
  final GenreModel genres;

  GenresState({@required this.genres});
}

class Initial extends GenresState {}

class Error extends GenresState {}

class Loading extends GenresState {}

class LoadedGenres extends GenresState {
  LoadedGenres({@required GenreModel genres})
      : assert(genres != null),
        super(genres: genres);
}
