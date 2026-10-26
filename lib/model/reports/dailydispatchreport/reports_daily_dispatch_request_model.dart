class ReportsDailyDispatchRequestModel {
  final String fromDate;
  final String toDate;
  final String tenantCode;
  final int currentPage;
  final int rowSize;
  final String? globalSearch;
  final String? bdoNo;
  final String? buyerName;
  final String? destination;
  final String? doNo;
  final String? soNo;

  ReportsDailyDispatchRequestModel({
    required this.fromDate,
    required this.toDate,
    required this.tenantCode,
    this.currentPage = 1,
    this.rowSize = 15,
    this.globalSearch,
    this.bdoNo,
    this.buyerName,
    this.destination,
    this.doNo,
    this.soNo,
  });

  Map<String, dynamic> toJson() {
    return {
      "FromDate": fromDate,
      "ToDate": toDate,
      "TenantCode": tenantCode,
      "currentPage": currentPage,
      "rowSize": rowSize,
      "GlobalSearch": globalSearch,
      "bdoNo": bdoNo,
      "buyerName": buyerName,
      "destination": destination,
      "doNo": doNo,
      "soNo": soNo,
    };
  }
}

class ReportsDailyDispatchResponseModel {
  final String? doNo;
  final String? bdoNo;
  final String? soNo;
  final String? buyerName;
  final String? destination;
  final String? materialName;
  final double? demandQty;
  final int? todayTrips;
  final int? cummTrips;
  final double? todayQuantity;
  final double? cummQuantity;
  final double? balanceQty;
  final String? customerReference;

  ReportsDailyDispatchResponseModel({
    this.doNo,
    this.bdoNo,
    this.soNo,
    this.buyerName,
    this.destination,
    this.materialName,
    this.demandQty,
    this.todayTrips,
    this.cummTrips,
    this.todayQuantity,
    this.cummQuantity,
    this.balanceQty,
    this.customerReference,
  });

  factory ReportsDailyDispatchResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportsDailyDispatchResponseModel(
      doNo: json['doNo'] as String?,
      bdoNo: json['bdoNo'] as String?,
      soNo: json['soNo'] as String?,
      buyerName: json['buyerName'] as String?,
      destination: json['destination'] as String?,
      materialName: json['materialName'] as String?,

      // Safely parsing numeric values to double
      demandQty: (json['demandQty'] as num?)?.toDouble(),
      todayTrips: json['todayTrips'] as int?,
      cummTrips: json['cummTrips'] as int?,
      todayQuantity: (json['todayQuantity'] as num?)?.toDouble(),
      cummQuantity: (json['cummQuantity'] as num?)?.toDouble(),
      balanceQty: (json['balanceQty'] as num?)?.toDouble(),

      customerReference: json['customerReference'] as String?,
    );
  }
}