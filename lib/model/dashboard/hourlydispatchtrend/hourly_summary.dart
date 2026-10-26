class HourlySummaryRequest {
  final String reportDate;
  final String tenantCode;

  HourlySummaryRequest({
    required this.reportDate,
    required this.tenantCode,
  });

  factory HourlySummaryRequest.fromJson(Map<String, dynamic> json) {
    return HourlySummaryRequest(
      reportDate: json['ReportDate'] ?? '',
      tenantCode: json['tenantCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ReportDate': reportDate,
      'tenantCode': tenantCode,
    };
  }
}
class HourlySummaryResponse {
  final String? hour;
  final int? soTrips;
  final int? stoTrips;
  final double? soTonnage;
  final double? stoTonnage;

  HourlySummaryResponse({
    this.hour,
    this.soTrips,
    this.stoTrips,
    this.soTonnage,
    this.stoTonnage,
  });

  factory HourlySummaryResponse.fromJson(Map<String, dynamic> json) {
    return HourlySummaryResponse(
      hour: json['hour'] as String?,
      soTrips: json['sO_Trips'] as int?,
      stoTrips: json['stO_Trips'] as int?,
      soTonnage: (json['sO_Tonnage'] as num?)?.toDouble(),
      stoTonnage: (json['stO_Tonnage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'sO_Trips': soTrips,
      'stO_Trips': stoTrips,
      'sO_Tonnage': soTonnage,
      'stO_Tonnage': stoTonnage,
    };
  }
}