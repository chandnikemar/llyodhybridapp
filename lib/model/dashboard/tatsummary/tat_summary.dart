class TatSummaryRequest {
  final String tenantCode;
  final String fromDate;
  final String toDate;

  TatSummaryRequest({
    required this.tenantCode,
    required this.fromDate,
    required this.toDate,
  });

  factory TatSummaryRequest.fromJson(Map<String, dynamic> json) {
    return TatSummaryRequest(
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

class TatSummaryResponse {
  final String? direction;
  final int? completedTransactions;
  final String? minTat;
  final String? maxTat;
  final String? avgTat;

  TatSummaryResponse({
    this.direction,
    this.completedTransactions,
    this.minTat,
    this.maxTat,
    this.avgTat,
  });

  factory TatSummaryResponse.fromJson(Map<String, dynamic> json) {
    return TatSummaryResponse(
      direction: json['direction'] as String?,
      completedTransactions: json['completedTransactions'] as int?,
      minTat: json['minTAT'] as String?,
      maxTat: json['maxTAT'] as String?,
      avgTat: json['avgTAT'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direction': direction,
      'completedTransactions': completedTransactions,
      'minTAT': minTat,
      'maxTAT': maxTat,
      'avgTAT': avgTat,
    };
  }
}