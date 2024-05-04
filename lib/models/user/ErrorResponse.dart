class ErrorResponse {
  final String message;
  final ErrorDetails errors;

  ErrorResponse({required this.message, required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] as String,
      errors: ErrorDetails.fromJson(json['errors'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errors': errors.toJson(),
    };
  }
}

class ErrorDetails {
  final List<String> email;

  ErrorDetails({required this.email});

  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    return ErrorDetails(
      email: List<String>.from(json['email'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
