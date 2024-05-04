class UserRegisterResponse {
  User? user;
  String? token;

  UserRegisterResponse({this.user, this.token});

  factory UserRegisterResponse.fromJson(Map<String, dynamic> json) =>
      UserRegisterResponse(
        user: User.fromJson(json['user']),
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'user': user!.toJson(),
        'token': token,
      };
}

class User {
  String? name;
  String? email;
  int? tipo;
  int id;

  User({
    this.name,
    this.email,
    this.tipo,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        tipo: json['Tipo'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'tipo': tipo,
        'id': id,
      };
}
