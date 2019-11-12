import 'package:flutter/material.dart';

abstract class UsersEvent {}

class LoadUser extends UsersEvent {}

class LoadUserMoviesByList extends UsersEvent {
  final int listId;
  LoadUserMoviesByList({@required this.listId}) : assert(listId != null);
}

class LoadUserMoviesFavorite extends UsersEvent {}

class LoadUserMoviesWatchlist extends UsersEvent {}

class LoadUserTvFavorite extends UsersEvent {}

class LoadUserTvWatchlist extends UsersEvent {}
