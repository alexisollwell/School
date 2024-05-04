class UserRegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirm;
  final String type;

  UserRegisterRequest(
      {required this.name,
      required this.email,
      required this.password,
      required this.passwordConfirm,
      required this.type});

  factory UserRegisterRequest.fromJson(Map<String, dynamic> json) {
    return UserRegisterRequest(
      name: json['name'].toString(),
      email: json['email'].toString(),
      password: json['password'].toString(),
      passwordConfirm: json['password_confirmation'].toString(),
      type: json['tipo'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirm,
      'tipo': type,
    };
  }
}
