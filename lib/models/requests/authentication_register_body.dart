class AuthenticationRegisterBody {
  String firstName;
  String lastName;
  String birthDate;
  String gender;
  int cityId;
  String email;
  String username;
  String password;
  String confirmPassword;
  String language;

  AuthenticationRegisterBody({
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.cityId,
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
    this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "BirthDate": birthDate,
      "Gender": gender,
      "CityId": cityId,
      "Email": email,
      "Username": username,
      "Password": password,
      "ConfirmPassword": confirmPassword,
      "Language": language,
    };
  }
}
