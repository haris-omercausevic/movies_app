import 'dart:convert';
import 'dart:io';

import 'package:movies_app/config/keys.dart';
import 'package:movies_app/models/entities/movie.dart';
import 'package:meta/meta.dart';
import 'package:movies_app/models/entities/movie_details.dart';
import 'package:movies_app/models/entities/movie_item.dart';

import 'package:movies_app/repositories/all.dart';
import 'package:movies_app/utilities/api_client.dart';

class MoviesRepository extends BaseRepository {
  final StorageRepository storageRepository;
  // final _apiKey = "802b2c4b88ea1183e50e6b285a27696e";
  // final _apiKeyBearer =
  //     "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZDE2ZTBkY2MxYjlkMDhkYTJlZThlY2E5YTc0ZTEyMyIsInN1YiI6IjVkYmVjZTcyZWZlMzdjMDAxODgzMjU2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rI5-34HOrqT66qObs1M5hqtA-UVtYsWzaRF08YngJiU";

  // final accountId = "5dbece72efe37c0018832568";
  // final accessToken =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE1NzI3OTQzMjgsInN1YiI6IjVkYmVjZTcyZWZlMzdjMDAxODgzMjU2OCIsImp0aSI6IjE2NDUxMzYiLCJhdWQiOiI2ZDE2ZTBkY2MxYjlkMDhkYTJlZThlY2E5YTc0ZTEyMyIsInNjb3BlcyI6WyJhcGlfcmVhZCIsImFwaV93cml0ZSJdLCJ2ZXJzaW9uIjoxfQ.lBw3FNKCVvVZ3DPPJfU6ljOa0sgtHtAm3Lg_FLj8UV4";

  String RouteMoviePopular = "/3/movie/popular";
  String RouteDiscoverMovie = "/3/discover/movie";
  String RouteSearchMovie = "/3/search/movie";
  String RouteMovieDetails = "/3/movie"; // /{id}  

  MoviesRepository({
    @required ApiClient apiClient,
    @required this.storageRepository,
  })  : assert(storageRepository != null),
        super(apiClient: apiClient);

  Future<MovieModel> getMovies({int genreId = 0, int page = 1}) async {
    try {
      int comedyId = 35; // hardcoded for now

      final response = genreId == 0
          ? await super.apiClient.get(
              RouteMoviePopular,
              queryParameters: {"page": page},
            )
          : await super.apiClient.get(
              RouteDiscoverMovie,
              queryParameters: {"with_genres": comedyId, "page": page},
            );

      if (response.statusCode == HttpStatus.ok) {
        return MovieModel.fromJson(response.data);
      } else {
        throw Exception("Error code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<MovieDetailsModel> getMovieById({@required int movieId}) async {
    try {
      final response =
          await super.apiClient.get(RouteMovieDetails + "/$movieId");

      if (response.statusCode == HttpStatus.ok) {
        return MovieDetailsModel.fromJson(response.data);
      } else {
        throw Exception("Error code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<MovieModel> getMoviesSearch({String query, int page = 1}) async {
    try {
      final response = await super.apiClient.get(
        RouteSearchMovie,
        queryParameters: {"query": query, "page": page},
      );
      MovieModel podaci;
      if (response.statusCode == HttpStatus.ok) {
        podaci = MovieModel.fromJson(response.data);
        return podaci;
      } else {
        throw Exception(
            "Error code: ${response.statusCode}, MESSAGE: ${response.statusMessage}");
      }
    }on Exception catch (e) {
      print("HARIS EXC:" + e.toString() + e.runtimeType.toString());
      
    }
    return null;
  }

  List<MovieItem> getSearchHistory() {
    var searchHistory = storageRepository.getString(Keys.searchHistoryListKey);
    var parsedJson = searchHistory != null ? json.decode(searchHistory) : null;

    List<MovieItem> history = [];
    if (parsedJson != null) {
      for (int i = 0; i < parsedJson.length; i++) {
        MovieItem result = MovieItem.fromJson(parsedJson[i], isUrl: true);
        history.add(result);
      }
    }

    return history;
  }

  Future<bool> setSearchHistory(List<MovieItem> history) async {
    return storageRepository.setString(
            Keys.searchHistoryListKey, json.encode(history));
  }

  // Future<GenreModel> getGenres() async {
  //   //ne koristi se jos
  //   try {
  //     String uri = "/3/genre/movie/list";

  //     final response =
  //         await super.apiClient.get(uri, queryParameters: {"api_key": _apiKey});
  //     if (response.statusCode == HttpStatus.ok) {
  //       return GenreModel.fromJson(response.data);
  //     } else {
  //       throw Exception("Error code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  // Future<List<GenreModel>> getGenresList() async {
  //   //ne koristi se jos
  //   try {
  //     String uri = "/3/genre/movie/list?api_key=$_apiKey";

  //     final response = await super.apiClient.get(uri);
  //     if (response.statusCode == HttpStatus.ok) {
  //       final items = json.decode(response.data).cast<Map<String, dynamic>>();
  //       List<GenreModel> listofGenres = items.map<GenreModel>((json) {
  //         return GenreModel.fromJson(json);
  //       }).toList();

  //       return listofGenres;
  //     } else {
  //       throw Exception("Error code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
}
