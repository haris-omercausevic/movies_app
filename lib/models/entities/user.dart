class User {
  int id;
  String firstName;
  String lastName;
  String birthDate;
  String gender;
  String country;
  String region;
  String city;
  String photoPath;
  String email;
  String username;
  int cityId;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.country,
    this.region,
    this.city,
    this.photoPath,
    this.email,
    this.username,
    this.cityId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      birthDate: json["birthDate"],
      gender: json["gender"],
      country: json["country"],
      region: json["region"],
      city: json["city"],
      photoPath: json["photoPath"],
      email: json["email"],
      username: json["username"],
      cityId: json["cityId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "birthDate": birthDate,
      "gender": gender,
      "country": country,
      "region": region,
      "city": city,
      "photoPath": photoPath,
      "email": email,
      "username": username,
      "cityId": cityId,
    };
  }
}
