class UserModel {
  String iso_639_1;
  int id;
  int featured;
  String description;
  double revenue;
  String account_object_id;
  String name;
  String updated_at;
  String created_at;
  String sort_by;
  String backdrop_path;
  int runtime;
  double average_rating;
  String iso_3166_1;
  bool adult;
  int number_of_items;

  UserModel({
    this.iso_639_1,
    this.id,
    this.featured,
    this.description,
    this.revenue,
    this.account_object_id,
    this.name,
    this.updated_at,
    this.created_at,
    this.sort_by,
    this.backdrop_path,
    this.average_rating,
    this.runtime,
    this.iso_3166_1,
    this.adult,
    this.number_of_items,
  });

//pripaziti da se proslijedi json.results[0], a ne citav json objekat sa page, total_pages
  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    iso_639_1 = parsedJson['iso_639_1'];
    id = parsedJson['id'];
    featured = parsedJson['featured'];
    description = parsedJson['description'];
    revenue = parsedJson['revenue'];
    account_object_id = parsedJson['account_object_id'];
    name = parsedJson['name'];
    updated_at = parsedJson['updated_at'];
    created_at = parsedJson['created_at'];
    sort_by = parsedJson['sort_by'];
    backdrop_path = parsedJson['backdrop_path'];
    runtime = parsedJson['runtime'];
    average_rating = parsedJson['average_rating'];
    iso_3166_1 = parsedJson['iso_3166_1'];
    adult = parsedJson['adult'];
    number_of_items = parsedJson['number_of_items'];
  }
}
