class GenreModel {
  List<GenreItemModel> genres;

  GenreModel({this.genres});
   GenreModel.fromJson(Map<String, dynamic> json) {
    GenreModel(genres: null);
  }
}

class GenreItemModel {
  int id;
  String name;

  GenreItemModel({this.id, this.name});
  GenreItemModel.fromJson(Map<String, dynamic> json) {
    GenreItemModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
