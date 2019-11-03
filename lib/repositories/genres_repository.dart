import 'package:meta/meta.dart';
import 'package:movies_app/models/entities/genre.dart';
import 'package:movies_app/repositories/base_repository.dart';
import 'package:movies_app/repositories/storage_repository.dart';
import 'package:movies_app/utilities/api_client.dart';

class GenresRepository extends BaseRepository {
  final StorageRepository storageRepository;

  GenresRepository({
    @required ApiClient apiClient,
    @required this.storageRepository,
  })  : assert(storageRepository != null),
        super(apiClient: apiClient);


  Future<GenreModel> getGenres() async{
    try{

    }
    catch(e){
      print(e);
    }

    return null;
  }
}
