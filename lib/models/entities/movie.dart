import 'movie_item.dart';

class MovieModel {
  int page;
  int total_results;
  int total_pages;
  List<MovieItem> results = [];

  MovieModel.fromJson(Map<String, dynamic> parsedJson) {
    page = parsedJson['page'];
    total_results = parsedJson['total_results'];
    total_pages = parsedJson['total_pages'];
    List<MovieItem> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      MovieItem result = MovieItem.fromJson(parsedJson['results'][i]);
      temp.add(result);
    }
    results = temp;
  }

  MovieModel({
    this.page,
    this.total_pages,
    this.results,
    this.total_results,
  });
}
