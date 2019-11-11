import 'package:movies_app/config/app_settings.dart';

class MovieItem {
  int vote_count;
  int id;
  bool video;
  double vote_average;
  String title;
  double popularity;
  String poster_path;
  String original_language;
  String original_title;
  List<int> genre_ids = [];
  String backdrop_path;
  bool adult;
  String overview;
  String release_date;

  final imagePath = AppSettings.imageUrlW185;

   MovieItem.fromJson(Map<String, dynamic> parsedJson, {bool isUrl = false}) {
    vote_count = parsedJson['vote_count'] as int;
    id = parsedJson['id'];
    video = parsedJson['video'];
    vote_average = parsedJson['vote_average'] + 0.0;
    title = parsedJson['title'];
    popularity = parsedJson['popularity'] + 0.0;
    if (isUrl == true) {
      poster_path =
          parsedJson['poster_path'];
    } else {
      poster_path = "$imagePath${parsedJson['poster_path']}";
    }
    original_language = parsedJson['original_language'];
    original_title = parsedJson['original_title'];
    for (int i = 0; i < parsedJson['genre_ids'].length; i++) {
      genre_ids.add(parsedJson['genre_ids'][i]);
    }
    backdrop_path = parsedJson['backdrop_path'];
    adult = parsedJson['adult'];
    overview = parsedJson['overview'];
    release_date = parsedJson['release_date'];
  }

  Map<String, dynamic> toJson() => {
        'vote_count': vote_count,
        'id': id,
        'video': video,
        'vote_average': vote_average,
        'title': title,
        'popularity': popularity,
        'poster_path': poster_path,
        'original_language': original_language,
        'original_title': original_title,
        'genre_ids': genre_ids,
        'backdrop_path': backdrop_path,
        'adult': adult,
        'overview': overview,
        'release_date': release_date,
      };
  
}
