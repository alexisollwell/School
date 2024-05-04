class UpdatePassword{
  String password;
  UpdatePassword({
    required this.password
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }
}