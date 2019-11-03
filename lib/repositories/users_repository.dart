import 'dart:io';
import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:movies_app/config/all.dart';
import 'package:movies_app/models/all.dart';
import 'package:movies_app/repositories/all.dart';
import 'package:movies_app/utilities/api_client.dart';

class UsersRepository extends BaseRepository {
  final StorageRepository storageRepository;

  UsersRepository({
    @required ApiClient apiClient,
    @required this.storageRepository,
  })  : assert(storageRepository != null),
        super(apiClient: apiClient);

  void setUnauthorizedCallback(Function callback) {
    apiClient.setUnauthorizedCallback(callback);
  }

  Future<User> authenticate(AuthenticationLoginBody body) async {
    try {
      final response = await super.apiClient.post(
            "/authentication/login",
            data: body,
          );

      if (response.statusCode == HttpStatus.ok) {
        final jwt = response.data["jwt"];
        final user = User.fromJson(response.data["user"]);

        await setCurrentUserJwt(jwt);
        await setCurrentUser(user);

        return user;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<User> facebookLogin(AuthenticationFacebookLoginBody body) async {
    try {
      final response = await super.apiClient.post(
            "/authentication/facebooklogin",
            data: body,
          );

      if (response.statusCode == HttpStatus.ok) {
        final jwt = response.data["jwt"];
        final user = User.fromJson(response.data["user"]);

        await setCurrentUserJwt(jwt);
        await setCurrentUser(user);

        return user;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<bool> register(AuthenticationRegisterBody body) async {
    try {
      final response = await super.apiClient.post(
            "/authentication/register",
            data: body,
          );

      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      print(e);
    }

    return false;
  }

  User getCurrentUser() {
    var currentUserString = storageRepository.getString(Keys.currentUser);

    return currentUserString != null ? User.fromJson(json.decode(currentUserString)) : null;
  }

  Future<bool> setCurrentUserCityId(int cityId) async {
    var user = getCurrentUser();
    if (user != null) {
      user.cityId = cityId;

      return await setCurrentUser(user);
    }

    return false;
  }

  Future<bool> setCurrentUser(User user) async {
    return storageRepository.setString(Keys.currentUser, json.encode(user.toJson()));
  }

  Future<bool> setCurrentUserJwt(String jwt) {
    super.apiClient.setAuthorizationHeader(jwt);
    return storageRepository.setString(Keys.jwt, jwt);
  }

  String getCurrentUserJwt() {
    return storageRepository.getString(Keys.currentUser);
  }

  Future<bool> removeCurrentUser() async {
    super.apiClient.setAuthorizationHeader(null);

    bool jwtRemoved = await storageRepository.remove(Keys.jwt);
    bool userRemoved = await storageRepository.remove(Keys.currentUser);

    return jwtRemoved && userRemoved;
  }
}
