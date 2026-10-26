class SalesSOSCPORequest {
  final String fromDate;
  final String toDate;
  final String tenantCode;
  final String reportType; // "SO", "SC", or "PO"
  final String globalSearch;
  final String cdoNumber;
  final int currentPage;
  final String customerName;
  final String customerReference;
  final String materialCode;
  final String materialName;
  final int rowSize;
  final String salesContractNumber;
  final String shipLocation;
  final String soNumber;

  SalesSOSCPORequest({
    required this.fromDate,
    required this.toDate,
    required this.tenantCode,
    required this.reportType,
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
      'ReportType': reportType,
      'GlobalSearch': globalSearch,
      'cdoNumber': cdoNumber,
      'CurrentPage': currentPage,
      'customerName': customerName,
      'customerReference': customerReference,
      'materialCode': materialCode,
      'materialName': materialName,
      'rowSize': rowSize,
      'salesContractNumber': salesContractNumber,
      'shipLocation': shipLocation,
      'soNumber': soNumber,
    };
  }
}

class SalesSOSCPOResponse {
  final int? soNumber;
  final String? soDate;
  final String? customerCode;
  final String? customerName;
  final String? shipToCode;
  final String? shipLocation;
  final String? customerReference;
  final String? salesContractNumber;
  final String? materialCode;
  final String? materialName;
  final String? cdoNumbers;
  final int? totalCDONumbers;
  final double? totalCDOQty;
  final double? totalActualWeight;
  final double? totalDispatchedQty;
  final double? totalAllocatedQty;
  final double? soQuantity;
  final double? totalBalanceQty;
  final int? totalTruckTrips;
  final String? senderPlant;
  final String? salesContractDate;
  final double? salesContractQuantity;

  SalesSOSCPOResponse({
    this.soNumber, this.soDate, this.customerCode, this.customerName, this.shipToCode,
    this.shipLocation, this.customerReference, this.salesContractNumber, this.materialCode,
    this.materialName, this.cdoNumbers, this.totalCDONumbers, this.totalCDOQty,
    this.totalActualWeight, this.totalDispatchedQty, this.totalAllocatedQty,
    this.soQuantity, this.totalBalanceQty, this.totalTruckTrips, this.senderPlant,
    this.salesContractDate, this.salesContractQuantity,
  });

  factory SalesSOSCPOResponse.fromJson(Map<String, dynamic> json) {
    return SalesSOSCPOResponse(
      soNumber: json['soNumber'] as int?,
      soDate: json['soDate'] as String?,
      customerCode: json['customerCode'] as String?,
      customerName: json['customerName'] as String?,
      shipToCode: json['shipToCode'] as String?,
      shipLocation: json['shipLocation'] as String?,
      customerReference: json['customerReference'] as String?,
      salesContractNumber: json['salesContractNumber'] as String?,
      materialCode: json['materialCode'] as String?,
      materialName: json['materialName'] as String?,
      cdoNumbers: json['cdoNumbers'] as String?,
      totalCDONumbers: json['totalCDONumbers'] as int?,
      totalCDOQty: (json['totalCDOQty'] as num?)?.toDouble(),
      totalActualWeight: (json['totalActualWeight'] as num?)?.toDouble(),
      totalDispatchedQty: (json['totalDispatchedQty'] as num?)?.toDouble(),
      totalAllocatedQty: (json['totalAllocatedQty'] as num?)?.toDouble(),
      soQuantity: (json['soQuantity'] as num?)?.toDouble(),
      totalBalanceQty: (json['totalBalanceQty'] as num?)?.toDouble(),
      totalTruckTrips: json['totalTruckTrips'] as int?,
      senderPlant: json['senderPlant'] as String?,
      salesContractDate: json['salesContractDate'] as String?,
      salesContractQuantity: (json['salesContractQuantity'] as num?)?.toDouble(),
    );
  }
}