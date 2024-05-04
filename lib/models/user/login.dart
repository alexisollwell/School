class UserCredentials {
  final String email;
  final String password;

  UserCredentials({required this.email, required this.password});

  // Método para deserializar el JSON a una instancia de UserCredentials
  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  // Método para serializar la instancia de UserCredentials a JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserCredentialsResponse {
  final String? token;
  final int? tipo;
  final int? idUsuario;

  UserCredentialsResponse({this.token, this.tipo, this.idUsuario});

  // Método para deserializar el JSON a una instancia de AuthToken
  factory UserCredentialsResponse.fromJson(Map<String, dynamic> json) {
    return UserCredentialsResponse(
      token: json['token'] as String,
      tipo: json['tipo'] as int,
      idUsuario: json['id'] as int,
    );
  }

  // Método para serializar la instancia de AuthToken a JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'tipo': tipo,
    };
  }
}
