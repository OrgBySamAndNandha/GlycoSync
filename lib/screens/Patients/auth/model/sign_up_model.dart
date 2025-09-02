// lib/app/auth/signup/model/signup_model.dart

class SignUpModel {
  String email;
  String password;
  String confirmPassword;

  SignUpModel({this.email = '', this.password = '', this.confirmPassword = ''});
}
