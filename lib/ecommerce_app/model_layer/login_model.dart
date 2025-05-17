class LoginModel{
  String? token;

  LoginModel({this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
    );
  }
}