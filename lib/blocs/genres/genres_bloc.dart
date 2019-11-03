import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

import 'package:movies_app/repositories/genres_repository.dart';
import 'package:movies_app/blocs/genres/all.dart';

class GenresBloc extends Bloc<GenresEvent, GenresState>{
  final GenresRepository genresRepository;

  GenresBloc({@required this.genresRepository}): assert(genresRepository != null);

  @override
  // DONE: implement initialState
  GenresState get initialState => Initial();

  @override
  Stream<GenresState> mapEventToState(GenresEvent event) async*{
    if(event is LoadGenres){
      yield* _loadGenres();
    }
  }

  Stream<GenresState> _loadGenres() async*{
    yield Loading();
    var genres = await genresRepository.getGenres();
    yield genres != null? LoadedGenres(genres: genres): Error(); 
  }
}

