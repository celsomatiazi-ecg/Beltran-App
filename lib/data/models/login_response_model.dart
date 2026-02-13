final class LoginModel {
  String accessToken;
  String refreshToken;

  LoginModel({required this.accessToken, required this.refreshToken});

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }
}
