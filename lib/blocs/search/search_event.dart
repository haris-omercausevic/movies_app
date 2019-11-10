import 'package:flutter/material.dart';
import 'package:movies_app/models/entities/movie_item.dart';

abstract class SearchEvent {}

class LoadSearch extends SearchEvent {
  final String query;
  LoadSearch({@required this.query}) : assert(query != null);
}
class SetHistory extends SearchEvent{
  final List<MovieItem> history;
  SetHistory(this.history);
}

class LoadHistory extends SearchEvent {}
