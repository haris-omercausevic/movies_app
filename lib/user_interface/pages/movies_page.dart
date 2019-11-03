import 'package:movies_app/blocs/movies/all.dart';
import 'package:movies_app/models/entities/movie.dart';
import 'package:movies_app/repositories/movies_repository.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/utilities/localization/localizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesPage extends StatefulWidget {
  MoviesPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  MoviesBloc moviesBloc;
  @override
  void didChangeDependencies() {
    moviesBloc = BlocProvider.of<MoviesBloc>(context);
    //moviesBloc.add(LoadMainPage());
    //moviesBloc.add(LoadMainPage());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // DONE: implement build

    return Scaffold(
        body: BlocBuilder<MoviesBloc, MoviesState>(
            bloc: moviesBloc,
            builder: (BuildContext context, MoviesState state) {
              if (state is Loading) {
                return Loader();
              } else if (state is LoadedMainPage) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => moviesBloc.add(LoadMovies()),
                        child: Text(
                          "Load Popular Movies",
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () =>
                            moviesBloc.add(LoadMoviesByGenre(genreId: 35)),
                        child: Text(
                          "Load Comedy Movies",
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      // FutureBuilder<List<GenresModel>>(
                      //     future: moviesBloc.moviesRepository.getGenresList(),
                      //     builder: (BuildContext context,
                      //         AsyncSnapshot<List<GenresModel>> snapshot) {
                      //       if (!snapshot.hasData)
                      //         return CircularProgressIndicator();
                      //       return DropdownButton<GenresModel>(
                      //         items: snapshot.data
                      //             .map((genre) => DropdownMenuItem<GenresModel>(
                      //                   child: Text(genre.name),
                      //                   value: genre,
                      //                 ))
                      //             .toList(),
                      //         onChanged: (GenresModel value) {
                      //           setState(() {
                      //             _currentGenre = value;
                      //           });
                      //         },
                      //         isExpanded: false,
                      //         //value: _currentUser,
                      //         hint: Text('Select Genre'),
                      //       );
                      //     }),
                    ],
                  ),
                );
              } else if (state is LoadedMovies) {
                return buildColumnWithData(state.movies);
                // return Container(
                //   padding: EdgeInsets.all(10.0),
                //   child: Column(
                //     children: <Widget>[
                //       Row(
                //         children: <Widget>[
                //           Center(
                //             child: RaisedButton(
                //               color: Colors.blue[300],
                //               onPressed: () => print("Pressed"),
                //               hoverColor: Colors.green,
                //             ),
                //           ),
                //         ],
                //       ),
                //       Expanded(child: buildColumnWithData(state.movies))
                //     ],
                //   ),
                // );
                // Text("${fromDate.toLocal()}"),
                // SizedBox(
                //   height: 20.0,
                // ),
                // RaisedButton(
                //   onPressed: () => _selectDate(context, fromDate),
                //   child: Text('Select date'),
                // ),
                // Text("${toDate.toLocal()}"),
                // SizedBox(
                //   height: 20.0,
                // ),
                // RaisedButton(
                //   onPressed: () => _selectDate(context, toDate),
                //   child: Text('Select date'),
                // ),
              }

              return ErrorPage();
            }));
  }

  // Future<Null> _selectDate(BuildContext context, DateTime date) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: date,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != date) {
  //     setState(() {
  //       date = picked;
  //     });
  //   }
  // }

  Widget buildColumnWithData(MovieModel movies) {
    return GridView.builder(
      itemCount: movies.results.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: GridTile(
            footer: Text(
              movies.results[index].title,
              style: TextStyle(color: Colors.white),
            ),
            child: Image.network(
              "https://image.tmdb.org/t/p/w185${movies.results[index].poster_path}", //ovaj request hendlat negdje drugo
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
