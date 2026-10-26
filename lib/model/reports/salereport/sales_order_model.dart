class SalesReportRequest {
  final String fromDate;
  final String toDate;
  final String tenantCode;
  final String globalSearch;
  final String cdoNumber;
  final int currentPage;
  final String customerName;
  final String customerReference;
  final String materialCode;
  final String materialName;
  final int rowSize;
  final String salesContractNumber;
  final String shipLocation; // NEW
  final String soNumber;

  SalesReportRequest({
    required this.fromDate,
    required this.toDate,
    required this.tenantCode,
    this.globalSearch = "",
    this.cdoNumber = "",
    this.currentPage = 1,
    this.customerName = "",
    this.customerReference = "",
    this.materialCode = "",
    this.materialName = "",
    this.rowSize = 15,
    this.salesContractNumber = "",
    this.shipLocation = "",
    this.soNumber = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'FromDate': fromDate,
      'ToDate': toDate,
      'TenantCode': tenantCode,
      'GlobalSearch': globalSearch,
      'cdoNumber': cdoNumber,
      'CurrentPage': currentPage,
      'customerName': customerName,
      'customerReference': customerReference,
      'materialCode': materialCode,
      'materialName': materialName,
      'rowSize': rowSize,
      'salesContractNumber': salesContractNumber,
      'shipLocation': shipLocation, // NEW
      'soNumber': soNumber,
    };
  }
}

class SalesReportResponse {
  final int? soNumber;
  final String? soDate;
  final String? customerCode;
  final String? customerName;
  final String? shipToCode;
  final String? shipLocation;
  final String? cdoNumber;
  final String? publishedOn;
  final double? cdoQty;
  final double? dispatchedQty;
  final double? allocatedQty;
  final double? balanceQty;
  final String? status;
  final String? senderPlant;
  final int? noOfTruckTrips;
  final double? actualWeight;
  final double? soQuantity;
  final String? materialCode;
  final String? materialName;
  final String? customerReference;
  final String? salesContractNumber;
  final double? totalDispatchedQtyPerSO;
  final String? poDate;

  SalesReportResponse({
    this.soNumber,
    this.soDate,
    this.customerCode,
    this.customerName,
    this.shipToCode,
    this.shipLocation,
    this.cdoNumber,
    this.publishedOn,
    this.cdoQty,
    this.dispatchedQty,
    this.allocatedQty,
    this.balanceQty,
    this.status,
    this.senderPlant,
    this.noOfTruckTrips,
    this.actualWeight,
    this.soQuantity,
    this.materialCode,
    this.materialName,
    this.customerReference,
    this.salesContractNumber,
    this.totalDispatchedQtyPerSO,
    this.poDate,
  });

  factory SalesReportResponse.fromJson(Map<String, dynamic> json) {
    return SalesReportResponse(
      soNumber: json['soNumber'] as int?,
      soDate: json['soDate'] as String?,
      customerCode: json['customerCode'] as String?,
      customerName: json['customerName'] as String?,
      shipToCode: json['shipToCode'] as String?,
      shipLocation: json['shipLocation'] as String?,
      cdoNumber: json['cdoNumber'] as String?,
      publishedOn: json['publishedOn'] as String?,
      cdoQty: (json['cdoQty'] as num?)?.toDouble(),
      dispatchedQty: (json['dispatchedQty'] as num?)?.toDouble(),
      allocatedQty: (json['allocatedQty'] as num?)?.toDouble(),
      balanceQty: (json['balanceQty'] as num?)?.toDouble(),
      status: json['status'] as String?,
      senderPlant: json['senderPlant'] as String?,
      noOfTruckTrips: json['noOfTruckTrips'] as int?,
      actualWeight: (json['actualWeight'] as num?)?.toDouble(),
      soQuantity: (json['soQuantity'] as num?)?.toDouble(),
      materialCode: json['materialCode'] as String?,
      materialName: json['materialName'] as String?,
      customerReference: json['customerReference'] as String?,
      salesContractNumber: json['salesContractNumber'] as String?,
      totalDispatchedQtyPerSO: (json['totalDispatchedQtyPerSO'] as num?)?.toDouble(),
      poDate: json['poDate'] as String?,
    );
  }
}