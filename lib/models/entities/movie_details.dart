import 'package:movies_app/models/entities/all.dart';

//Ne koristi se jos
class MovieDetailsModel {
  String title;
  List<GenreItemModel> genres;
  String tagline;
  String overview;
  String release_date;
  MovieDetailsModel.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson['title'];

    List<GenreItemModel> temp = [];
    for (int i = 0; i < parsedJson['genres'].length; i++) {
      GenreItemModel result = GenreItemModel.fromJson(parsedJson['results'][i]);
      temp.add(result);
    }
    genres = temp;

  }

Map<String, dynamic> toJson(){
    return {
      "title":title,
      "genres":title,
    };
}

}
