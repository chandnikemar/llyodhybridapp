class VehicleQueueRequest {
  final String fromDate;
  final String toDate;
  final String tenantCode;

  VehicleQueueRequest({
    required this.fromDate,
    required this.toDate,
    required this.tenantCode,
  });

  factory VehicleQueueRequest.fromJson(Map<String, dynamic> json) {
    return VehicleQueueRequest(
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      tenantCode: json['tenantCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate,
      'toDate': toDate,
      'tenantCode': tenantCode,
    };
  }
}

class VehicleQueueResponse {
  final String? stage;
  final String? transactionType;
  final int? vehicleCount;

  VehicleQueueResponse({
    this.stage,
    this.transactionType,
    this.vehicleCount,
  });

  factory VehicleQueueResponse.fromJson(Map<String, dynamic> json) {
    return VehicleQueueResponse(
      stage: json['stage'] as String?,
      transactionType: json['transactionType'] as String?,
      vehicleCount: json['vehicleCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'transactionType': transactionType,
      'vehicleCount': vehicleCount,
    };
  }
}