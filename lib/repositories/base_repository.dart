import 'package:meta/meta.dart';

import 'package:movies_app/utilities/api_client.dart';

abstract class BaseRepository {
  final ApiClient apiClient;

  BaseRepository({@required this.apiClient}) : assert(apiClient != null);
}
