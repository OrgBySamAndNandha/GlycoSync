// lib/app/auth/signup/models/signup_model.dart

class SignUpModel {
  String email;
  String password;
  String confirmPassword;

  SignUpModel({this.email = '', this.password = '', this.confirmPassword = ''});
}
