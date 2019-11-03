class AuthenticationFacebookLoginBody {
  String id;
  String name;
  String profilePic;
  String email;
  String firstName;
  String lastName;
  String gender;

  AuthenticationFacebookLoginBody({
    this.id,
    this.name,
    this.profilePic,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Name": name,
      "ProfilePic": profilePic,
      "Email": email,
      "FirstName": firstName,
      "LastName": lastName,
      "Gender": gender,
    };
  }
}
