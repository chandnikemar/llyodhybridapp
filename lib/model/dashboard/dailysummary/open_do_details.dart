class OpenDoRequest {
  final String fromDate;
  final String toDate;
  final String tenantCode;

  OpenDoRequest({
    required this.fromDate,
    required this.toDate,
    required this.tenantCode,
  });

  factory OpenDoRequest.fromJson(Map<String, dynamic> json) {
    return OpenDoRequest(
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
class OpenDoResponse {
  final String? transactionType;
  final int? openDoCount;
  final double? totalPendingQuantity;

  OpenDoResponse({
    this.transactionType,
    this.openDoCount,
    this.totalPendingQuantity,
  });

  factory OpenDoResponse.fromJson(Map<String, dynamic> json) {
    return OpenDoResponse(
      transactionType: json['transactionType'] as String?,
      openDoCount: json['openDOCount'] != null ? (json['openDOCount'] as num).toInt() : 0,
      totalPendingQuantity: (json['totalPendingQuantity'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'openDOCount': openDoCount,
      'totalPendingQuantity': totalPendingQuantity,
    };
  }
}