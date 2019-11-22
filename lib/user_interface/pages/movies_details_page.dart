import 'package:flutter/material.dart';
import 'package:movies_app/models/entities/movie_item.dart';

class MoviesDetailsPage extends StatelessWidget {
  static const routeName = "/Movies/Details";
  final MovieItem movieItem;
  MoviesDetailsPage({this.movieItem}) : assert(movieItem != null);

  @override
  Widget build(BuildContext context) {    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Image.network(
            movieItem.poster_path,
            fit: BoxFit.cover,
          ),
          Text(movieItem.title),
          Text("Vote average:" + movieItem.vote_average.toDouble().toString()),
          Text("Votes:" + movieItem.vote_count.toString()),
          FlatButton(
            child: Text(
              "Add to favorites",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => print("not yet imlemented."),            
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
