import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/repositories/movies_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:movies_app/config/all.dart';
import 'package:movies_app/application.dart';

import 'package:movies_app/blocs/users/users_bloc.dart';
import 'package:movies_app/blocs/authentication/authentication_bloc.dart';

import 'package:movies_app/repositories/all.dart';
import 'package:movies_app/config/app_settings.dart';
import 'package:movies_app/utilities/api_client.dart';

ApiClient initializeApiClient(String jwt) {
  return ApiClient()
      .setContentType("application/json")
      .setBaseUrl(AppSettings.apiUrl)
      .setAuthorizationHeader(jwt);
}

void main() {
  runZoned<Future<Null>>(
    () async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final StorageRepository storageRepository =
          StorageRepository(sharedPreferences: sharedPreferences);

      final ApiClient apiClient =
          initializeApiClient(storageRepository.getString(Keys.jwt));

      runApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MoviesRepository>(
              builder: (context) => MoviesRepository(
                apiClient: apiClient,
                storageRepository: storageRepository,
              ),
            ),
            RepositoryProvider<UsersRepository>(
              builder: (context) => UsersRepository(
                apiClient: apiClient,
                storageRepository: storageRepository,
              ),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<MoviesBloc>(
                builder: (context) => MoviesBloc(
                  moviesRepository:
                      RepositoryProvider.of<MoviesRepository>(context),
                ),
              ),
              BlocProvider<AuthenticationBloc>(
                builder: (context) => AuthenticationBloc(
                  usersRepository:
                      RepositoryProvider.of<UsersRepository>(context),
                ),
              ),
              BlocProvider<UsersBloc>(
                builder: (context) => UsersBloc(
                  usersRepository:
                      RepositoryProvider.of<UsersRepository>(context),
                ),
              ),
            ],
            child: Application(),
          ),
        ),
      );
    },
  );
}
