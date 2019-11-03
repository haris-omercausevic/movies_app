import 'package:flutter/material.dart';

abstract class UsersEvent {}

class LoadCurrentUser extends UsersEvent {}

class SetCurrentUserLocation extends UsersEvent {
  final int cityId;

  SetCurrentUserLocation({@required this.cityId}) : assert(cityId != null);
}
