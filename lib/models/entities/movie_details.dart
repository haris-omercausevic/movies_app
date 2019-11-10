class MovieDetailsModel {
  String title;
  MovieDetailsModel.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson['title'];
  }

Map<String, dynamic> toJson(){
    return {
      "title":title,
    };
}

}
