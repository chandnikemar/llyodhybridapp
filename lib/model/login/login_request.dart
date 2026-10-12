class LoginRequest {
  final String userName;
  final String password;

  LoginRequest({
    required this.userName,
    required this.password,
  });

  // Convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}