import 'dart:convert';
import 'dart:io';

import 'package:movies_app/models/entities/genre.dart';
import 'package:movies_app/models/entities/movie.dart';
import 'package:meta/meta.dart';

import 'package:movies_app/repositories/all.dart';
import 'package:movies_app/utilities/api_client.dart';

class MoviesRepository extends BaseRepository {
  final StorageRepository storageRepository;
  final _apiKey = "802b2c4b88ea1183e50e6b285a27696e";
  final _apiKeyBearer =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZDE2ZTBkY2MxYjlkMDhkYTJlZThlY2E5YTc0ZTEyMyIsInN1YiI6IjVkYmVjZTcyZWZlMzdjMDAxODgzMjU2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rI5-34HOrqT66qObs1M5hqtA-UVtYsWzaRF08YngJiU";

  final accountId = "5dbece72efe37c0018832568";
  final accessToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE1NzI3OTQzMjgsInN1YiI6IjVkYmVjZTcyZWZlMzdjMDAxODgzMjU2OCIsImp0aSI6IjE2NDUxMzYiLCJhdWQiOiI2ZDE2ZTBkY2MxYjlkMDhkYTJlZThlY2E5YTc0ZTEyMyIsInNjb3BlcyI6WyJhcGlfcmVhZCIsImFwaV93cml0ZSJdLCJ2ZXJzaW9uIjoxfQ.lBw3FNKCVvVZ3DPPJfU6ljOa0sgtHtAm3Lg_FLj8UV4";

  String RouteMoviePopular = "/3/movie/popular";
  String RouteDiscoverMovie = "/3/discover/movie";

  MoviesRepository({
    @required ApiClient apiClient,
    @required this.storageRepository,
  })  : assert(storageRepository != null),
        super(apiClient: apiClient);

  Future<MovieModel> getMovies({int genreId = 0}) async {
    try {
      int comedyId = 35;

      final response = genreId == 0
          ? await super.apiClient.get(
              RouteMoviePopular,
              queryParameters: {"api_key": _apiKey},
            )
          : await super.apiClient.get(
              RouteDiscoverMovie,
              queryParameters: {"api_key": _apiKey, "with_genres": comedyId},
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

  Future<GenreModel> getGenres() async {
    //ne koristi se jos
    try {
      String uri = "/3/genre/movie/list";

      final response =
          await super.apiClient.get(uri, queryParameters: {"api_key": _apiKey});
      if (response.statusCode == HttpStatus.ok) {
        return GenreModel.fromJson(response.data);
      } else {
        throw Exception("Error code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<GenreModel>> getGenresList() async {
    //ne koristi se jos
    try {
      String uri = "/3/genre/movie/list?api_key=$_apiKey";

      final response = await super.apiClient.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final items = json.decode(response.data).cast<Map<String, dynamic>>();
        List<GenreModel> listofGenres = items.map<GenreModel>((json) {
          return GenreModel.fromJson(json);
        }).toList();

        return listofGenres;
      } else {
        throw Exception("Error code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
