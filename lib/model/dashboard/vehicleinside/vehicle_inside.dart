class VehicleInsideRequest {
  final String tenantCode;
  final String fromDate;
  final String toDate;

  VehicleInsideRequest({
    required this.tenantCode,
    required this.fromDate,
    required this.toDate,
  });

  factory VehicleInsideRequest.fromJson(Map<String, dynamic> json) {
    return VehicleInsideRequest(
      tenantCode: json['tenantCode'] ?? '',
      fromDate: json['FromDate'] ?? '',
      toDate: json['ToDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantCode': tenantCode,
      'FromDate': fromDate,
      'ToDate': toDate,
    };
  }
}

class VehicleInsideResponse {
  final String? direction;
  final String? transactionStatus;
  final String? category;
  final int? transactionCount;

  VehicleInsideResponse({
    this.direction,
    this.transactionStatus,
    this.category,
    this.transactionCount,
  });

  factory VehicleInsideResponse.fromJson(Map<String, dynamic> json) {
    return VehicleInsideResponse(
      direction: json['direction'] as String?,
      transactionStatus: json['transactionStatus'] as String?,
      category: json['category'] as String?,
      transactionCount: json['transactionCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direction': direction,
      'transactionStatus': transactionStatus,
      'category': category,
      'transactionCount': transactionCount,
    };
  }
}