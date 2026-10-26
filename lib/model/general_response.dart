class GeneralResponse {
  final String? errorMessage;
  final String? exception;
  final String? responseMessage;
  final bool? isSuccess;
  final int? statusCode;

  GeneralResponse({
    this.errorMessage,
    this.exception,
    this.responseMessage,
    this.isSuccess,
    this.statusCode,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) {
    return GeneralResponse(
      errorMessage: json['errorMessage'] ?? "",
      exception: json['exception'] ?? "",
      responseMessage: json['responseMessage'] ?? '',
      isSuccess: json['isSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorMessage': errorMessage,
      'exception': exception,
      'responseMessage': responseMessage,
      'isSuccess': isSuccess,
      'statusCode': statusCode,
    };
  }
}
