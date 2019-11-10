import 'package:flutter/material.dart';

abstract class SearchEvent {}

class LoadSearch extends SearchEvent {}

class SaveToWishlist extends SearchEvent {
  final int movieId;
  SaveToWishlist({@required this.movieId}) : assert(movieId != null);
}
