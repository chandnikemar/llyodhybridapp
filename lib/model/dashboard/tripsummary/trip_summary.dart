class TripSummaryRequest {
  final String tenantCode;
  final String fromDate;
  final String toDate;

  TripSummaryRequest({
    required this.tenantCode,
    required this.fromDate,
    required this.toDate,
  });

  factory TripSummaryRequest.fromJson(Map<String, dynamic> json) {
    return TripSummaryRequest(
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

class TripSummaryResponse {
  final String? direction;
  final String? transactionStatus;
  final String? category;
  final int? transactionCount;

  TripSummaryResponse({
    this.direction,
    this.transactionStatus,
    this.category,
    this.transactionCount,
  });

  factory TripSummaryResponse.fromJson(Map<String, dynamic> json) {
    return TripSummaryResponse(
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