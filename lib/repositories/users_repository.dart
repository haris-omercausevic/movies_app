import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:movies_app/config/keys.dart';
import 'package:movies_app/models/all.dart';

import 'package:movies_app/repositories/base_repository.dart';
import 'package:movies_app/repositories/storage_repository.dart';
import 'package:movies_app/utilities/api_client.dart';
import 'package:movies_app/models/entities/user.dart';

class UsersRepository extends BaseRepository {
  final StorageRepository storageRepository;
  final _apiKey = "802b2c4b88ea1183e50e6b285a27696e";
  final _apiKeyBearer =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZDE2ZTBkY2MxYjlkMDhkYTJlZThlY2E5YTc0ZTEyMyIsInN1YiI6IjVkYmVjZTcyZWZlMzdjMDAxODgzMjU2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rI5-34HOrqT66qObs1M5hqtA-UVtYsWzaRF08YngJiU";

  final accountId = "5dbece72efe37c0018832568";
  final accessToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE1NzI3OTQzMjgsInN1YiI6IjVkYmVjZTcyZWZlMzdjMDAxODgzMjU2OCIsImp0aSI6IjE2NDUxMzYiLCJhdWQiOiI2ZDE2ZTBkY2MxYjlkMDhkYTJlZThlY2E5YTc0ZTEyMyIsInNjb3BlcyI6WyJhcGlfcmVhZCIsImFwaV93cml0ZSJdLCJ2ZXJzaW9uIjoxfQ.lBw3FNKCVvVZ3DPPJfU6ljOa0sgtHtAm3Lg_FLj8UV4";

      String ActionsLists = "list";
      String ActionsMovieFavorites = "movie/favorites";
      String ActionsMovieWatchlist = "movie/watchlist";
      String ActionsTvFavorites = "tv/favorites";
      String ActionsTvWatchlist = "tv/watchlist";

      String routeRequestTokenNew = "/3/authentication/token/new";

  UsersRepository({
    @required ApiClient apiClient,
    @required this.storageRepository,
  })  : assert(storageRepository != null),
        super(apiClient: apiClient);

Future<String> getRequestToken() async{
try{
    final responseRequestToken = await super.apiClient.get(routeRequestTokenNew);
    if(responseRequestToken.statusCode == HttpStatus.ok){
      return responseRequestToken.data['request_token'];
    }
  }
  catch(e){
    print(e);
  }

  return null;
}
Future<UserModel> authenticationSimulator() async{

  try{ final responseRequestToken = await super.apiClient.get(routeRequestTokenNew);
    if(responseRequestToken.statusCode == HttpStatus.ok){
      return responseRequestToken.data['request_token'];
    }
  }
  catch(e){
    print(e);
  }

  return null;
}
//ovo bi se inace trebalo izvrsiti nakon uspjesnog logina
  Future<UserListModel> getUserLists() async {
    try {
      String RouteAccount = "/4/account/$accountId/";
      final response = await super.apiClient.get(RouteAccount + ActionsLists);
      if(response.statusCode == HttpStatus.ok){
        return UserListModel.fromJson(response.data);
      }
      else{
        throw Exception("Error code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

   Future<bool> setCurrentUser(UserModel user) async {
    return storageRepository.setString(Keys.currentUser, json.encode(user.toJson()));
  }

//ovo se izvrsi u mainu automatski zasad jer nema logina, komplikovano token dobit bez logiranja na pravu stranicu
  Future<bool> setCurrentUserJwt(String jwt) {
    super.apiClient.setAuthorizationHeader(jwt);
    return storageRepository.setString(Keys.jwt, jwt);
  }
}
