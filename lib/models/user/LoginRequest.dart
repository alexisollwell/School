class LoginRequest {
  final String userName;
  final String password;

  LoginRequest(this.userName, this.password);

  Map<String, String> toMap() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}