import 'movie_item.dart';

class MovieModel {
  int page;
  int totalresults;
  int totalpages;
  List<MovieItem> results = [];

  MovieModel.fromJson(Map<String, dynamic> parsedJson) {
    page = parsedJson['page'];
    totalresults = parsedJson['totalresults'];
    totalpages = parsedJson['totalpages'];
    List<MovieItem> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      MovieItem result = MovieItem(parsedJson['results'][i]);
      temp.add(result);
    }
    results = temp;
  }

  MovieModel({
    this.page,
    this.totalpages,
    this.results,
    this.totalresults,
  });
}
